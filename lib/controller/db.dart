// this is a database helper file. It's main purpose to make
// working with database easy and simple.

import 'package:daytask/models/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  // we called a private constructor and make a static instance and a static
  // database so that there will be only one instance and
  // database during the whole execution

  DBProvider._();

  static final DBProvider instance = DBProvider._();
  static Database? _database;

  // this function returns a database. If a database exists then it
  // will return that database, otherwise it will create a new database
  // and return that.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    // Set default value to the User Table row.
    // _database!.insert(K.tableNameUser, {
    //   K.colNameUser["currency"]!: "\$",
    //   K.colNameUser["currencyMode"]!: 1,
    // });

    return _database!;
  }

  // this function will create a new database with a table
  // with appropriate column names
  Future<Database> _initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'daytask.db'),
        onCreate: (db, version) async {
      await db.execute('''CREATE TABLE ${FixedTaskTable.name} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          ${FixedTaskTable.colTaskTitle} TEXT NOT NULL
        )''');
      await db.execute('''CREATE TABLE ${TaskTable.name} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TaskTable.colTaskDate} TEXT NOT NULL,
          ${TaskTable.colIsChecked} INTEGER NOT NULL,
          ${TaskTable.colTaskTitle} TEXT NOT NULL
        )''');

      // Demo data For test
      // Write demo data here
    }, version: 1);
  }

  // this function takes a table name and a map of data to insert to the table
  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<int> update(String tableName, Map<String, dynamic> row,
      {String? where, List<Object?>? whereArgs}) async {
    Database db = await instance.database;
    return await db.update(tableName, row, where: where, whereArgs: whereArgs);
  }

  // this function query all data from table that's name passed as a argument
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> query(
    String tableName, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    Database db = await instance.database;
    return await db.query(tableName, where: where, whereArgs: whereArgs);
  }

  // this function will drops the table as given table name
  // and creates an empty table there
  Future<void> dropTable(String tableName) async {
    Database db = await instance.database;
    String dbPath = join(await getDatabasesPath(), 'quidtrails.db');
    await db.execute('''DROP DATABASE $dbPath''');
  }
}
