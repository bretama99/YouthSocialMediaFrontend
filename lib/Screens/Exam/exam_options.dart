import 'package:flutter/material.dart';
import 'package:youth_and_adolesence/Models/possible_answers.dart';
import 'package:youth_and_adolesence/Models/question.dart';
import 'package:youth_and_adolesence/Models/question_option_entity.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';
import 'exam_page.dart';
import '../../Models/category.dart';

class ExamOptionsDialog extends StatefulWidget {
  final Category category;

  const ExamOptionsDialog({Key key, this.category}) : super(key: key);

  @override
  _ExamOptionsDialogState createState() => _ExamOptionsDialogState();
}

class _ExamOptionsDialogState extends State<ExamOptionsDialog> {
  int _noOfQuestions;
  String _difficulty;
  bool processing;
  DatabaseHelper databaseHelper = DatabaseHelper();
  Question questionEntity = new Question.empty();
  List<QuestionOptionEntity> question = [];
  List<List<QuestionOptionEntity>> questionList = [];

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "Easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Text(
              widget.category.categoryName,
              style: Theme.of(context).textTheme.title.copyWith(),
            ),
          ),
          SizedBox(height: 10.0),
          Text("Select Total Number of Questions"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: Text("10"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 5
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(5),
                ),
                ActionChip(
                  label: Text("20"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 20
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(20),
                ),
                ActionChip(
                  label: Text("30"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 30
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(30),
                ),
                ActionChip(
                  label: Text("40"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 40
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(40),
                ),
                ActionChip(
                  label: Text("50"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 50
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(50),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Text("Select Difficulty"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: Text("Any"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "Any"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("Any"),
                ),
                ActionChip(
                  label: Text("Easy"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "Easy"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("Easy"),
                ),
                ActionChip(
                  label: Text("Medium"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "Medium"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("Medium"),
                ),
                ActionChip(
                  label: Text("Hard"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "Hard"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("Hard"),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          processing
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: Text("Start Quiz"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: _startQuiz,
                ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });

//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((database) async {
//      print('DB done');
//      Future<List<QuestionOptionEntity>> list =  questionEntity.getSingleQuestionWithItsOptions(1,10,_difficulty);
//      Future<List<QuestionOptionEntity>> list2 =  questionEntity.getSingleQuestionWithItsOptions(3,10,_difficulty);
//      list.then((value) =>  questionList.add(value)  );
//      list2.then((value) =>  questionList.add(value)  );
//      List<Question> getQuestionsList = await questionEntity.getQuestionList();
//      print(getQuestionsList[0].question);

    var queryResult = await questionEntity.getQuestions(
        widget.category.categoryId, _noOfQuestions, _difficulty);

    var listOfQuestion = await questionEntity.queryQuestions(widget.category.categoryId, _noOfQuestions, _difficulty);
    var count = await questionEntity.getQuestionCount();
    var count2 = await PossibleAnswer.empty().getOptionCount();
    print('Question Count: $count');
    print('Option Count: $count2');
    setState(() {
      questionList = queryResult;
    });
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamPage(
          questions: listOfQuestion,
          category: widget.category,
          noOfQuestions: _noOfQuestions,
          difficulty: _difficulty,
        ),
      ),
    );
    setState(() {
      processing = false;
    });
  }
}
