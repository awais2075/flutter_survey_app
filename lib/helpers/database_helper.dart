import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final String _dbName = 'survey.db';
  static final int _dbVersion = 1;
  static final String _dbTableName = 'tb_location';

  static final colLocationId = 'location_id';
  static final colLocationName = 'location_name';
  static final colLocationAddress = 'location_address';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, _dbName);

    return await openDatabase(dbPath, version: _dbVersion, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) {
    String sqlQuery = '''
          CREATE TABLE $_dbTableName (
            survey_id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone_number TEXT NOT NULL,
            address TEXT NOT NULL,
            location TEXT NOT NULL,
            remarks TEXT NOT NULL,
            latitude TEXT NOT NULL,
            longitude TEXT NOT NULL
          )
          ''';
    db.execute(sqlQuery);
  }

  Future<int> insert(Map<String, dynamic> value) async {
    Database database = await instance.database;
    return database.insert(_dbTableName, value);
  }

  Future<List<Map<String, dynamic>>> getAllRows() async {
    Database database = await instance.database;
    return await database.query(_dbTableName);
  }

  Future<int> deleteById(int id) async {
    Database database = await instance.database;
    return await database.delete(_dbTableName, where: 'survey_id = $id');
  }
}
