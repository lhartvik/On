import 'package:on_app/model/logg.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class LocalDBHelper implements DatabaseHelper {
  static const _databaseName = 'pmed_database.db';
  static const _databaseVersion = 1;
  static const _tableName = 'pmed';

  LocalDBHelper._privateConstructor();
  static final LocalDBHelper instance = LocalDBHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        event TEXT NOT NULL,
        timestamp TEXT
      )
    ''');
  }

  @override
  Future<void> insert(String event) async {
    Database db = await instance.database;
    await db.insert(_tableName, {
      'event': event,
      'timestamp': DateTime.now().toUtc().toIso8601String()
    });
  }

  @override
  Future<List<Logg>> readAllLogs() async {
    Database db = await instance.database;
    var dbentries = await db.query(_tableName, orderBy: 'timestamp DESC');
    return dbentries.isNotEmpty
        ? dbentries.map((entry) => Logg.fromJsonDatabase(entry)).toList()
        : [];
  }

  @override
  void clearAll() async {
    Database db = await instance.database;
    db.delete(_tableName);
  }

  @override
  Future<DateTime?> lastMedicineTaken() async {
    Database db = await instance.database;
    var foo = await db.query(_tableName,
        columns: ['timestamp'],
        where: 'event = ?',
        whereArgs: ['Ta medisin'],
        orderBy: 'timestamp DESC',
        limit: 1);

    return foo.isNotEmpty
        ? DateTime.tryParse(foo.first['timestamp'] as String)?.toUtc()
        : null;
  }

  @override
  Future<bool> lastStatus() async {
    Database db = await instance.database;
    var sisteStatus = await db.query(_tableName,
        columns: ['event'],
        where: 'event = ? OR event = ?',
        whereArgs: ['On', 'Off'],
        orderBy: 'timestamp DESC',
        limit: 1);
    return sisteStatus.isNotEmpty ? sisteStatus.first['event'] == 'On' : false;
  }

  void insertAllLogs(List<Logg> value) async {
    var database = await instance.database;
    await database.transaction((txn) async {
      for (var logg in value) {
        await txn.insert(
            _tableName, {'event': logg.event, 'timestamp': logg.timestamp});
      }
    });
  }
}
