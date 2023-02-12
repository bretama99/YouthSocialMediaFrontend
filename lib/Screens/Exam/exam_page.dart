import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:youth_and_adolesence/Models/question.dart';
import 'package:youth_and_adolesence/Models/question_option_entity.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';
import 'exam_finished.dart';
import '../../Models/category.dart';

class ExamPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;
  final String difficulty;
  final int noOfQuestions;

  ExamPage(
      {Key key,
      @required this.questions,
      this.category,
      this.noOfQuestions,
      this.difficulty})
      : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  Question questionEntity = new Question.empty();
  List<List<QuestionOptionEntity>> questionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
//    Question question = widget.questions[_currentIndex];
//    final List<dynamic> options = question.incorrectAnswers;
//    if(!options.contains(question.correctAnswer)) {
//      options.add(question.correctAnswer);
//      options.shuffle();
//    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.category.categoryName),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ),
//            FutureBuilder<List<List<QuestionOptionEntity>>>(
//                future: getQuestions(),
//                builder: (context,snapshot){
//              if (snapshot.connectionState == ConnectionState.waiting) {
//                return  Center(child: CircularProgressIndicator());
//              }  else{
//                if (snapshot.hasError){
//                  return Center(child: Column(
//                    children: <Widget>[
//                      Icon(Icons.error,size: 28,),
//                      Text('Error: ${snapshot.error}'),
//                    ],
//                  ));
//                }else{
//                  return ;
//                }
//              }
//            })

            widget.questions.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.bookOpen,
                          size: 60,
                        ),
                        Text(
                          "noQuestionsInThisCategory",
                          style: AppTheme.headline,
                        ).tr()
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                "${_currentIndex + 1}",
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                widget.questions[_currentIndex].question,
                                softWrap: true,
                                style: _questionStyle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ...widget.questions[_currentIndex].posibleAnswers
                                  .map((answer) {
                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: RadioListTile(
                                        title: Text(answer.labelValue),
                                        groupValue: _answers[_currentIndex],
                                        value: answer.labelValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _answers[_currentIndex] =
                                                answer.labelValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text(_currentIndex ==
                                          (widget.questions.length - 1)
                                      ? "submit".tr()
                                      : "next")
                                  .tr(),
                              onPressed: () => _nextSubmit(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("selectAnswerToContinue").tr(),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ExamFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

//  Future<List<List<QuestionOptionEntity>>> getQuestions(){
//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((value) async {
//        questionList = await questionEntity.getQuestions(widget.category.categoryId, widget.noOfQuestions, widget.difficulty);
//        print('length: ${questionList.length}');
//      return questionList;
//    });
//  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("quizExitWarning").tr(),
            title: Text("warning").tr(),
            actions: <Widget>[
              FlatButton(
                child: Text("yes").tr(),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("no").tr(),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
