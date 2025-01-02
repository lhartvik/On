import 'package:on_app/model/logg.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'pmed_database.db';
  static const _databaseVersion = 1;
  static const _tableName = 'pmed';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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

  Future<int> insert(String event) async {
    Database db = await instance.database;
    print('Loggan $event');
    return await db.insert(_tableName,
        {'event': event, 'timestamp': DateTime.now().toIso8601String()});
  }

  Future<List<Logg>> readAllLogs() async {
    Database db = await instance.database;
    var dbentries = await db.query(_tableName);
    print(dbentries);
    return dbentries.isNotEmpty
        ? dbentries.map((entry) => Logg.fromJsonDatabase(entry)).toList()
        : [];
  }

  void clearAll() async {
    Database db = await instance.database;
    db.delete(_tableName);
  }
}
