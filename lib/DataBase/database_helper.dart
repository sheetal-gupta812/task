import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:task/DataBase/product.dart';

class DataBaseHelper {

  static DataBaseHelper _databaseHelper = DataBaseHelper();    // Singleton DatabaseHelper
   late Database _database ;                // Singleton Database

  String todoTable = 'product_table';

  String colProductName = 'productName';
  String colLaunchSite = 'launchSite';
  String colLaunchAt = 'launchAt';
  String colDate = 'date';
  String colPopularity = 'popularity';

  DataBaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DataBaseHelper() {

    _databaseHelper = DataBaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {

    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'products.db';

    // Open/create the database at a given path
    var todosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $todoTable($colProductName TEXT PRIMARY KEY, $colLaunchSite TEXT, '
        '$colLaunchAt TEXT, $colDate TEXT, $colPopularity DOUBLE)');
  }

  Future<List<Map<String, dynamic>>> getTodoMapList(int s) async {
    Database db = await this.database;

    var result = await db.query(todoTable, orderBy: '$colDate DESC');
    switch(s)
    {
      case 0:
        result = await db.query(todoTable, orderBy: '"$colProductName" DESC');
        break;
      case 1:
        result = await db.query(todoTable, orderBy: '"$colDate" DESC');
        break;
      case 2:
        result = await db.query(todoTable, orderBy: '"$colLaunchSite" DESC');
        break;

      case 3:
        result = await db.query(todoTable, orderBy: '"$colPopularity" DESC');
        break;
      default:
        result = await db.query(todoTable, orderBy: '"$colDate" DESC');
    }

    return result;
  }

  // Insert Operation
  Future<int> insertTodo(Product todo) async {
    Database db = await database;
    var result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  // Update Operation
  Future<int> updateTodo(Product todo) async {
    var db = await this.database;
    var result = await db.update(todoTable, todo.toMap(), where: '$colProductName = ?', whereArgs: [todo.productName]);
    return result;
  }


  // Delete Operation
  Future<int> deleteTodo(String prodName) async {
    var db = await database;
    int result = await db.rawDelete('DELETE FROM $todoTable WHERE $colProductName = "$prodName"');
    return result;
  }

  // Get count
  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $todoTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }


  Future<List<Product>> getTodoList(int s) async {

    var todoMapList = await getTodoMapList(s); // Get 'Map List' from database
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<Product> todoList = [];
    for (int i = 0; i < count; i++) {
      todoList.add(Product.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }

}