import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Models/possible_answers.dart';
import 'package:youth_and_adolesence/Models/question.dart';
import 'package:youth_and_adolesence/Screens/Exam/update_question.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class ExamList extends StatefulWidget {
  @override
  _ExamListState createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {
  Category category = Category.empty();
  Question question = Question.empty();
  PossibleAnswer possibleAnswer = PossibleAnswer.empty();
  Future<List<Category>> list;
  Future<List<Question>> questionList;
  bool isFetching = false;
  bool isEmpty = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestionsCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.deepPurple,
        title: Text('questionBank').tr(),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () => {Navigator.pushNamed(context, '/addQuestion')})
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: fetchQuestions,
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 3, left: 5, right: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: TextFormField(
//                        controller: searchC,
                          textInputAction: TextInputAction.go,
                          onChanged: (val) {},
                          decoration: InputDecoration(
                            suffixIcon: Icon(CupertinoIcons.search),
                            hintText: 'searchQuestion'.tr(),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              buildFutureBuilder(),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: fetchQuestions,
        label: Text('sync').tr(),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  Widget buildFutureBuilder() {
    if (!isFetching && !isEmpty) {
      return FutureBuilder(
          future: questionList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.1),
                  child: Center(
                    child: SpinKitDoubleBounce(
                      color: AppTheme.accentColor,
                      size: 80,
                    ),
                  ),
                );
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        size: 50,
                      ),
                      Text('Error: ${snapshot.error}'),
                    ],
                  ));
                } else {
                  if (snapshot.data.length == 0) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.notWhite),
                        color: AppTheme.notWhite,
//                                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.handsHelping,
                            size: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "noQuestions",
                              style: AppTheme.textLabelLg,
                            ).tr(),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: buildList(snapshot.data));
                  }
                }
                break;
              default:
                return Center(
                    child: Container(
                  child: Text('somethingWentWrongTryAgain').tr(),
                ));
            }
          });
    } else if (isFetching && !isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDoubleBounce(
              color: AppTheme.accentColor,
              size: 80,
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text(
                'loadingStayPatient',
                style: AppTheme.textLabelLg,
              ).tr(),
            )
          ],
        ),
      );
    } else if (!isFetching && isEmpty) {
      return Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Icon(
                FontAwesomeIcons.batteryEmpty,
                size: 70,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.textsms,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text(
                    "noQuestionAtTheMoment".tr(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody(List<Question> questionList) {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowHeight: MediaQuery.of(context).size.height * 0.1,
          columns: [
            DataColumn(
              label: Text('Id'),
            ),
            DataColumn(
              label: Text('question').tr(),
            ),
            DataColumn(
              label: Text('answers').tr(),
            ),
            DataColumn(
              label: Text('level').tr(),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('edit').tr(),
            ),
            DataColumn(
              label: Text('delete').tr(),
            )
          ],
          rows: questionList
              .map(
                (q) => DataRow(cells: [
                  DataCell(
                    Text(q.questionId.toString()),
                  ),
//                  DataCell(
//                    Text(category.categoryId.toString()),
                  // Add tap in the row and populate the
                  // textfields with the corresponding values to update
//                    onTap: () {
//                      _showValues(employee);
//                      // Set the Selected employee to Update
//                      _selectedEmployee = employee;
//                      setState(() {
//                        _isUpdating = true;
//                      });
//                    },
//                  ),
                  DataCell(
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Wrap(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: [
                              Text(
                                q.question,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
//                      _showValues(employee);
//                      // Set the Selected employee to Update
//                      _selectedEmployee = employee;
//                      // Set flag updating to true to indicate in Update Mode
//                      setState(() {
//                        _isUpdating = true;
//                      });
                    },
                  ),
                  DataCell(
                      ExpansionTile(title: Text(q.posibleAnswers[0].label))),
                  DataCell(
                    Text(
                      q.level ?? '',
                    ),
                    onTap: () {
//                      _showValues(employee);
//                      // Set the Selected employee to Update
//                      _selectedEmployee = employee;
//                      setState(() {
//                        _isUpdating = true;
//                      });
                    },
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
//                      _deleteEmployee(employee);
                      },
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
//                      _deleteEmployee(employee);
                      },
                    ),
                  )
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<List<Question>> getQuestionsCache() async {
    setState(() {
      questionList = question.queryQuestions(0, 20, 'Any');
    });
    return questionList;
  }

  Widget buildAnswers(List<PossibleAnswer> list) {
    return Container(
//      height: MediaQuery.of(context).size.width*0.,
      width: MediaQuery.of(context).size.width * 0.3,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        list[index].label,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        list[index].labelValue,
                      ),
                    )
                  ],
                )
              ],
            );
          }),
    );
  }

  buildList(List<Question> list) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            child: ExpansionTile(
              title: Text(
                list[i].question,
              ),
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    ...list[i].posibleAnswers.map((answer) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(child: Chip(label: Text(answer.label))),
                          Expanded(
                              flex: 3,
                              child: Chip(label: Text(answer.labelValue))),
                        ],
                      );
                    })
                  ],
                )
              ],
            ),
            onLongPress: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton.icon(
                                icon: Icon(
                                  Icons.close,
                                  color: AppTheme.white,
                                ),
                                color: Theme.of(context).errorColor,
                                shape: AppTheme.roundedBorderMd,
                                onPressed: () {
//                                  Navigator.pop(context);
                                  deleteQuestion(list[i].questionId, context);
                                },
                                label: Text(
                                  'delete',
                                  style: TextStyle(
                                    color: AppTheme.white,
                                  ),
                                ).tr(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: RaisedButton.icon(
                              color: AppTheme.success,
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateQuestion(question: list[i])));
                              },
                              icon: Icon(
                                FontAwesomeIcons.save,
                                color: AppTheme.white,
                              ),
                              label: Text(
                                'update',
                                style: TextStyle(
                                  color: AppTheme.white,
                                ),
                              ).tr(),
                              shape: AppTheme.roundedBorderMd,
                            )),
                          ],
                        ),
                      ),
                    );
                  }).then((value) => value ? fetchQuestions() : null);
            },
          );
        });
  }

  deleteQuestion(int id, BuildContext context) {
    //TODO show dialog return value utilize it after deletion and insertion for all
    showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("deleteQuestionWarning").tr(),
            title: Text("deleteWarning").tr(),
            actions: <Widget>[
              OutlineButton.icon(
                label: Text(
                  "yes",
                  style: TextStyle(color: AppTheme.danger),
                ).tr(),
                onPressed: () {
                  dio.delete('/question/$id').then((res) {
                    if (res.statusCode == 200) {
                      Toast.show("deletionSuccessful".tr(), context,
                          backgroundColor: AppTheme.success, duration: 3);
                      Navigator.pop(context, true);
                    }
                  }).catchError((error) => {
                        Toast.show("somethingWentWrongTryAgain".tr(), context,
                            backgroundColor: AppTheme.danger, duration: 3)
                      });
                },
                icon: Icon(Icons.check_circle, color: AppTheme.danger),
              ),
              OutlineButton.icon(
                label: Text(
                  "no",
                  style: TextStyle(color: AppTheme.success),
                ).tr(),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: Icon(
                  Icons.close,
                  color: AppTheme.success,
                ),
              ),
            ],
          );
        }).then((value) => value ? Navigator.pop(context, true) : null);
  }

  Future fetchQuestions() async {
    setState(() {
      isFetching = true;
      isEmpty = false;
    });
    Future<Response> res = dio.get('/question');
    res.then((response) async {
      if (response.statusCode == 200) {
        List<PossibleAnswer> fetchedAnswers = [];
        List<Question> fetchedQuestions = [];
        for (int i = 0; i < response.data.length; i++) {
          var singleQuestion = Question.fromMapObject(response.data[i]);
          fetchedQuestions.add(singleQuestion);
          for (int optionsCount = 0;
              optionsCount < singleQuestion.posibleAnswers.length;
              optionsCount++) {
            var singleQuestionPossibleAns =
                singleQuestion.posibleAnswers[optionsCount];
            fetchedAnswers.add(singleQuestionPossibleAns);

            //insert or update a single possible answer
            PossibleAnswer cached = await possibleAnswer
                .getSingleAnswer(singleQuestionPossibleAns.posibleAnswerId);
            if (cached != null) {
              possibleAnswer.updateOption(singleQuestionPossibleAns);
            } else {
              possibleAnswer.insertOption(singleQuestionPossibleAns);
            }
          }

          //1)fetch question with options
          //2)insert or update question
          //3)inset or update option of that question

          //update or insert
          Question cached =
              await question.getSingleQuestion(singleQuestion.questionId);
          if (cached != null) {
            question.updateQuestion(singleQuestion);
          } else {
            question.insertQuestion(singleQuestion);
          }
        }
        //remove deleted answers and questions
        possibleAnswer.removeDeletedRows(fetchedAnswers);
        //remove deleted answers and questions
        question.removeDeletedRows(fetchedQuestions);
        Toast.show("updated".tr(), context);

        setState(() {
          isFetching = false;
          fetchedQuestions.isNotEmpty ? isEmpty = false : isEmpty = true;
        });
      }
      getQuestionsCache();
//      return getCategory();/
    }).catchError((error) {
      print(error);
//      Toast.show("somethingWentWrongTryAgain".tr(), context, duration: 3);
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('couldntFetchNewQuestions').tr()));
      setState(() {
        isFetching = false;
      });
    });
    return res;
  }
}
