import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
// A Flutter plugin for finding commonly used locations on the filesystem. Supports iOS and Android.
import 'package:path_provider/path_provider.dart';
import 'package:vocacional/models/Question.dart';

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

  //Get all objects from DB
  Future<List<Map<String, dynamic>>> getQuestionsMapList() async{
    Database db = await this.database;

    var result = await db.query(questionTable, orderBy: '$colId ASC');
    return result;
  }

  //insert operation, add question to db
  Future<int> insertQuestion(Question question) async {
    Database database = await this.database;
    var result = await database.insert(questionTable, question.toMap());
    return result;
  }

  //Update operation: Update a Question on the DB
  Future<int> updateQuestion(Question question) async {
    var database = await this.database;
    var result = await database.update(questionTable, question.toMap(), where: '$colId ?', whereArgs: [question.id]);
    return result;
  }
  
  //Delete operation, delete question from DB
  Future<int> deleteQuestion(int id) async {
    var database = await this.database;
    int result = await database.rawDelete('DELETE FROM $questionTable WHERE $colId = $id');
    return result;
  }

  //Get number of Questions in DB
  Future<int> getCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> x = await database.rawQuery('SELECT COUNT (*) from $questionTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get the Map list [List<Map>] and convert it to Question List [List<Note>]
  Future<List<Question>> getQuestionList() async {
    var questionMapList = await getQuestionsMapList();
    int count = questionMapList.length;

    List<Question> questionList = List<Question>();
    // For loop to create a 'Question List from 'Map List'

    for (int i = 0 ; i < count; i++) {
      questionList.add(Question.fromMapObject(questionMapList[i]));
    }

    return questionList;
  }

  //Get number of Questions in DB
  Future<int> getResultQuestion() async {
    var questionMapList = await getQuestionsMapList();
    int count = questionMapList.length;
    int resultLogic = 0;
    // For loop to create a 'Question List from 'Map List'

    for (int i = 0; i < count; i++) {
      if (!Question
          .fromMapObject(questionMapList[i])
          .responded) {
        return 0;
      } else {
        resultLogic += Question
            .fromMapObject(questionMapList[i])
            .amount;
      }
    }
    return resultLogic;
  }

  void createTestOne(){
    insertQuestion(Question("Hola", false, false, 1));
    insertQuestion(Question("Hola", false, false, 2));
    insertQuestion(Question("Hola", false, false, 3));
  }

  //update all col with default values to reset history
  void resetHistoryQuestions(Database dbOne, int newVersion) async {

    await dbOne.execute('UPDATE $questionTable SET $colResponse = 0, $colResponded = 0');
  }
}