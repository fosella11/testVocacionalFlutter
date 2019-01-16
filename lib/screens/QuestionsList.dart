import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocacional/utils/DatabaseHelper.dart';
import 'package:vocacional/models/Question.dart';

class QuestionsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QuestionsListState();
  }
}

class QuestionsListState extends State<QuestionsList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Question> questionList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (questionList == null) {
      questionList = List<Question>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Vocacional'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Call update DB
              //
              //Translate app Flutter TODO: https://medium.com/@anilcan/flutter-internationalization-by-using-json-files-f91468d86df0

              //
            },
          ),
          IconButton(
            icon: Icon(Icons.shop_two),
            onPressed: () {
              //
              //Call test number 2
              //
              databaseHelper.createTestOne();
            },
          ),
        ],
      ),
      body: getQuestionListView(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        debugPrint('Floating Button Clicked');
      }),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Question>> questionListFuture =
          databaseHelper.getQuestionList();
      questionListFuture.then((questionList) {
        setState(() {
          this.questionList = questionList;
          this.count = questionList.length;
        });
      });
    });
  }

  ListView getQuestionListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
      return ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            //
            //Add Logic Own ads or Not
            //Add Ads Admob
            //https://pub.dartlang.org/packages/firebase_admob
            //
            if(this.questionList[position].amount == 1){
              return Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: getColorStatusQuestion(this.questionList[position].responded)),
                        title: Text(
                          this.questionList[position].title,
                          style: titleStyle,
                        ),
                        subtitle: Text(this.questionList[position].id.toString()),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }else{
              return Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: getColorStatusQuestion(this.questionList[position].responded)),
                        title: Text(
                          this.questionList[position].title,
                          style: titleStyle,
                        ),
                        subtitle: Text(this.questionList[position].id.toString()),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('SI'),
                              onPressed: () {
                                Question q = this.questionList[position];
                                q.responded = 1;
                                q.response = 1;
                                _updateQuestion(q);
                                updateListView();
                              },
                            ),
                            FlatButton(
                              child: const Text('NO'),
                              onPressed: () {
                                Question q = this.questionList[position];
                                q.responded = 1;
                                q.response = 0;
                                _updateQuestion(q);
                                updateListView();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

          });
  }

  Color getColorStatusQuestion(int responded) {
    switch (responded) {
      case 1:
        return Colors.green;
        break;
      case 0:
        return Colors.grey;
        break;
      default:
        return Colors.grey;
    }
  }

  void _delete(BuildContext context, Question question) async {
    int result = await databaseHelper.deleteQuestion(question.id);
    if (result != 0) {
      _showSnackBar(context, "Updated item yes or no");
    }
  }


  // Save data to database
  void _updateQuestion(Question q) async {
    int result;
      result = await databaseHelper.updateQuestion(q);

    if (result == 0) {  // Success
      _showSnackBar(this.context, 'Algo esta mal! No se guardo la respuesta');
    }
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}
