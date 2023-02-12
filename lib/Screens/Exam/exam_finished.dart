import 'package:flutter/material.dart';
import 'package:youth_and_adolesence/Models/question.dart';
import 'package:youth_and_adolesence/Models/question_option_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Screens/Exam/exam_home.dart';

import 'check_answers.dart';

class ExamFinishedPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;
  final Map<int, dynamic> correctAnswers = {};

  ExamFinishedPage({Key key, @required this.questions, @required this.answers})
      : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    getCorrectAnswers();
    int correct = 0;
    this.answers.forEach((index, value) {
      if (this.correctAnswers[index] == value) {
        correct++;
      }
    });
    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('result').tr(),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("totalQuestions", style: titleStyle).tr(),
                  trailing: Text("${questions.length}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("score", style: titleStyle).tr(),
                  trailing: Text("${correct / questions.length * 100}%",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("correctAnswers", style: titleStyle).tr(),
                  trailing: Text("$correct/${questions.length}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("incorrectAnswers", style: titleStyle).tr(),
                  trailing: Text(
                      "${questions.length - correct}/${questions.length}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("goToHome").tr(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Text("checkAnswers").tr(),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(
                                questions: questions,
                                answers: answers,
                                correctAnswers: correctAnswers,
                              )));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void getCorrectAnswers() {
    for (int questionIndex = 0;
        questionIndex < this.questions.length;
        questionIndex++) {
      for (int i = 0; i < questions[questionIndex].posibleAnswers.length; i++) {
        if (this.questions[questionIndex].posibleAnswers[i].isAnswer == 1) {
          correctAnswers.addAll(
              {questionIndex: this.questions[questionIndex].posibleAnswers[i].labelValue});
        }
      }
    }
  }
}
