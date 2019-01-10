import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocacional/utils/DatabaseHelper.dart';
import 'package:vocacional/models/Question.dart';

class QuestionsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
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
              //
            },
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              //
              //Translate app Flutter TODO: https://medium.com/@anilcan/flutter-internationalization-by-using-json-files-f91468d86df0
              //
              //
              //Show result test 1 (Check in logic if the test is complete or toast)
              //
            },
          ),
          IconButton(
            icon: Icon(Icons.shop_two),
            onPressed: () {
              //
              //Call test number 2
              //
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
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: getColorStatusQuestion(0)),
              title: Text(
                this.questionList[position].title,
                style: titleStyle,
              ),
              subtitle: Text(this.questionList[position].id.toString()),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, questionList[position]);
                },
              ),
            ),
          );
        });
  }

  Color getColorStatusQuestion(int responded) {
    switch (responded) {
      case 1:
        return Colors.green;
        break;
      case 2:
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
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}
