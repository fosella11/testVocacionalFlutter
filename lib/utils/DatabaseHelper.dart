import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
// A Flutter plugin for finding commonly used locations on the filesystem. Supports iOS and Android.
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String questionTable = 'question_table';
  String colId = 'id';
  String colTitle = 'title';
  String colResponse = 'col_response';
  String colResponded = 'col_responded';
  String colAmount = 'col_amount';

  // the next line is named constructor, used to create instance of DataBaseHelper
  DatabaseHelper._createIntance();

  factory DatabaseHelper(){

    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createIntance(); // This line, must be executed only once, Singleton Object
    }
    return _databaseHelper;

  }

  Future<Database> get database async {

    if(_database == null){
      _database = await initializeDatabase();

    }
    return _database;

  }

  Future<Database> initializeDatabase() async {
    // First get the directory for android and IOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'questionTestOne.db';
    
    //Now we gonna open or create at a given path
    var questionDatabaseOne = await openDatabase(path, version: 1, onCreate: _createDbOne);
    return questionDatabaseOne;
  }

  void _createDbOne(Database dbOne, int newVersion) async {

    await dbOne.execute('CREATE TABLE $questionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colResponse INT, $colResponded INT, $colAmount INT)');
  }


  //DB CRUD

  Future<List<Map<String, dynamic>>> getQuestionsMapList() async{
    Database db = await this.database;

    var result = await db.query(questionTable, orderBy: '$colId ASC');
    return result;
  }

}
