import 'dart:async';

import 'package:on_app/model/logg.dart';
import 'package:on_app/model/plan.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class LocalDBHelper implements DatabaseHelper {
  static const _databaseName = 'pmed_database.db';
  static const _databaseVersion = 1;
  static const _logTableName = 'pmed';
  static const _planTableName = 'plan';

  LocalDBHelper._privateConstructor();
  static final LocalDBHelper instance = LocalDBHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_logTableName (
        event TEXT NOT NULL,
        timestamp TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $_planTableName (
        id TEXT PRIMARY KEY,
        medicine TEXT NOT NULL,
        time TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<Logg> insert(String event, {DateTime? tidspunkt}) async {
    Database db = await instance.database;
    tidspunkt ??= DateTime.now();
    Map<String, dynamic> eventJson = {
      'event': event,
      'timestamp': tidspunkt.toUtc().toIso8601String(),
    };

    await db.insert(_logTableName, eventJson);

    return Logg.fromJsonDatabase(eventJson);
  }

  Future<void> update(Logg newLog, Logg oldLog) async {
    Database db = await instance.database;
    await db.update(
      _logTableName,
      newLog.toJsonDatabase(),
      where: 'timestamp = ?',
      whereArgs: [oldLog.timestamp],
    );
  }

  @override
  Future<List<Logg>> readAllLogs() async {
    Database db = await instance.database;
    var dbentries = await db.query(_logTableName, orderBy: 'timestamp DESC');
    return dbentries.isNotEmpty
        ? dbentries.map((entry) => Logg.fromJsonDatabase(entry)).toList()
        : [];
  }

  @override
  void clearAll() async {
    Database db = await instance.database;
    db.delete(_logTableName);
  }

  @override
  Future<DateTime?> lastMedicineTaken() async {
    Database db = await instance.database;
    var foo = await db.query(
      _logTableName,
      columns: ['timestamp'],
      where: 'event = ?',
      whereArgs: ['Ta medisin'],
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    return foo.isNotEmpty
        ? DateTime.tryParse(foo.first['timestamp'] as String)?.toUtc()
        : null;
  }

  @override
  Future<bool> lastStatus() async {
    Database db = await instance.database;
    var sisteStatus = await db.query(
      _logTableName,
      columns: ['event'],
      where: 'event = ? OR event = ?',
      whereArgs: ['On', 'Off'],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    return sisteStatus.isNotEmpty ? sisteStatus.first['event'] == 'On' : false;
  }

  void insertAllLogs(List<Logg> value) async {
    var database = await instance.database;
    await database.transaction((txn) async {
      for (var logg in value) {
        await txn.insert(_logTableName, {
          'event': logg.event,
          'timestamp': logg.timestamp,
        });
      }
    });
  }

  Future<List<Plan>> getMedicinePlan() async {
    Database db = await instance.database;
    var dbentries = await db.query(_planTableName);

    print(dbentries);

    return dbentries.isNotEmpty
        ? dbentries.map((entry) => Plan.fromJsonDatabase(entry)).toList()
        : [];
  }

  void insertPlan(Plan plan) async {
    Database db = await instance.database;
    await db.insert(_planTableName, {
      'id': plan.id,
      'medicine': plan.medicine,
      'time': plan.tidString,
    });
  }

  void removePlan(String id) async {
    Database db = await instance.database;
    await db.delete(_planTableName, where: 'id = ?', whereArgs: [id]);
  }
}
