import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Models/possible_answers.dart';
import 'package:youth_and_adolesence/Models/question.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class AddQuestion extends StatefulWidget {
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

DatabaseHelper databaseHelper = DatabaseHelper();

class _AddQuestionState extends State<AddQuestion> {
  // empty constructor
  Category category = new Category.empty();
  Question question = new Question.empty();
  PossibleAnswer possibleAnswer = new PossibleAnswer.empty();

  //global form key controller
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  //Input Controller(C is indicated for controller)
  var questionTitleC = new TextEditingController();
  var isAnswer = new TextEditingController();

  var levels = ['Easy', 'Medium', 'Hard'];
  List<Category> categoryList = new List<Category>();
  String selectedLevel;
  int selectedCategory;
  String selectedAnswer;
  var lengthOfOptions = 4;
  List<Map<String, TextEditingController>> labelControllersList = [];
  List<Map<String, TextEditingController>> labelValueControllersList = [];
  var userId;
  var isProcessing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initOptionControllers();
    getCategory();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('addQuestion').tr(),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.fileImport), onPressed: () => {})
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (term) {},
                        controller: questionTitleC,
                        maxLines: 3,
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enterQuestion".tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.solidQuestionCircle,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
                          ),
                          labelText: 'question'.tr(),
                          isDense: true,
                          labelStyle: AppTheme.textLabelLg,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField(
                              hint: Text(
                                "questionLevel",
                                style: AppTheme.textLabelSm,
                              ).tr(),
                              validator: (term) => term == null
                                  ? "enterQuestionLevel".tr()
                                  : null,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Icon(
                                  FontAwesomeIcons.layerGroup,
                                  color: Theme.of(context).primaryColor,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                border: OutlineInputBorder(),
                                filled: false,
                              ),
                              items: levels
                                  .map((value) => DropdownMenuItem(
                                        child: Text(
                                          value,
                                        ),
                                        value: value,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedLevel = val;
                                });
                              },
                              value: selectedLevel,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField(
                              hint: Text("correctAnswer",
                                      style: AppTheme.textLabelSm)
                                  .tr(),
                              validator: (term) => term == null
                                  ? "enterCorrectAnswer".tr()
                                  : null,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Icon(
                                  FontAwesomeIcons.clipboardCheck,
                                  color: Theme.of(context).primaryColor,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                border: OutlineInputBorder(),
                                filled: false,
                              ),
                              items: labelControllersList
                                  .map((value) => DropdownMenuItem(
                                        child: Text(buildDropDownText(value)),
                                        value:
                                            value.toString().substring(16, 17),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedAnswer = val;
                                });
                              },
                              value: selectedAnswer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: DropdownButtonFormField(
                        hint:
                            Text("category", style: AppTheme.textLabelSm).tr(),
                        validator: (term) =>
                            term == null ? "enterCategory".tr() : null,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: Icon(
                            FontAwesomeIcons.objectGroup,
                            color: Theme.of(context).primaryColor,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          border: OutlineInputBorder(),
                          filled: false,
                        ),
                        items: categoryList
                            .map((value) => DropdownMenuItem(
                                  child: Text(value.categoryName),
                                  value: value.categoryId,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedCategory = val;
                          });
                        },
                        value: selectedCategory,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: buildListView(),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
//      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildPlusMinusButtons(),
            buildFloatingActionButton(),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return isProcessing
        ? CircularProgressIndicator()
        : FloatingActionButton.extended(
            onPressed: () => {
              if (_formKey.currentState.validate()) {addQuestion()}
            },
            label: Text('save').tr(),
            icon: Icon(FontAwesomeIcons.save),
          );
  }

  Widget buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: lengthOfOptions,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {},
                        controller: labelControllersList[index]
                            ['labelController$index'],
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enter option";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'label'.tr() + ' ${index + 1}',
                          isDense: true,
                          labelStyle: AppTheme.textLabelSm,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {},
                        controller: labelValueControllersList[index]
                            ['labelValueController$index'],
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enter label value ${index + 1}";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.dochub,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
                          ),
                          labelText: 'option'.tr() + ' ${index + 1}'.tr(),
                          isDense: true,
                          labelStyle: AppTheme.textLabelMd,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Row buildPlusMinusButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: () => addOption(),
        ),
        IconButton(
            icon: Icon(FontAwesomeIcons.minus),
            onPressed: () => decreaseOption()),
      ],
    );
  }

  addOption() {
    setState(() {
      var labelValueController = TextEditingController();
      var labelController = TextEditingController();
      labelValueControllersList
          .add({'labelValueController$lengthOfOptions': labelValueController});
      labelControllersList
          .add({'labelController$lengthOfOptions': labelController});
      ++lengthOfOptions;
    });
  }

  decreaseOption() {
    if (lengthOfOptions > 2) {
      setState(() {
        --lengthOfOptions;
        labelValueControllersList.removeAt(lengthOfOptions);
        labelControllersList.removeAt(lengthOfOptions);
      });
    }
  }

  void initOptionControllers() {
    for (int i = 0; i < lengthOfOptions; i++) {
      var labelController = TextEditingController();
      var labelValueController = TextEditingController();
      labelControllersList.add({'labelController$i': labelController});
      labelValueControllersList
          .add({'labelValueController$i': labelValueController});
    }
  }

  String buildDropDownText(Map<String, TextEditingController> value) {
    String controllerText = value.toString();
    var optionPosition = controllerText.substring(16, 17);
    int optionPositionInt = int.parse(optionPosition);
    ++optionPositionInt;
    return 'option'.tr() + ' ' + optionPositionInt.toString();
  }

  void getCategory() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) async {
      var newQuestion = Question(
          questionTitleC.text, selectedCategory, selectedLevel, "Admin");
      Future<List<Category>> categoryListFuture = category.getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
        });
      });
    });
  }

  //TODO:Import questions API
  addQuestion() {
    setState(() {
      isProcessing = true;
    });
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) async {
//      var newQuestion =
//          Question(questionTitleC.text, selectedCategory, "Easy", "Admin");
//      await question.insertQuestion(newQuestion).then((value) async {
//        print("QuestionId: " + value.toString());
//        var correctAnswerIndex = int.parse(selectedAnswer);
//        List<Map<String, dynamic>> answerList;
//        for (int i = 0; i < labelControllersList.length; i++) {
//          Map<String, dynamic> singleAnswer;
//          String labelOfCurrentIndex =
//              labelControllersList[i]['labelController$i'].text;
//          String labelValueOfCurrentIndex =
//              labelValueControllersList[i]['labelValueController$i'].text;
//          // set the option answer if the selected corrected answer index and option index are same
//          int isAnswer = correctAnswerIndex == i ? 1 : 0;
//          singleAnswer = {
//            "label": labelOfCurrentIndex,
//            "labelValue": labelValueOfCurrentIndex,
//            "isAnswer": isAnswer
//          };
//          answerList.add(singleAnswer);
//          var newOption = PossibleAnswer(labelOfCurrentIndex, value,
//              labelValueOfCurrentIndex, isAnswer, "Admin");
//          var res = await possibleAnswer.insertOption(newOption);
//        }
//        Navigator.pop(context);
//      });

      var correctAnswerIndex = int.parse(selectedAnswer);
      List<Map<String, dynamic>> answerList = [];
      for (int i = 0; i < labelControllersList.length; i++) {
        String labelOfCurrentIndex =
            labelControllersList[i]['labelController$i'].text;
        String labelValueOfCurrentIndex =
            labelValueControllersList[i]['labelValueController$i'].text;
        // set the option answer if the selected corrected answer index and option index are same
        int isAnswer = correctAnswerIndex == i ? 1 : 0;
        Map<String, dynamic> singleAnswer = {
          "label": labelOfCurrentIndex,
          "labelValue": labelValueOfCurrentIndex,
          "isAnswer": isAnswer
        };
        answerList.add(singleAnswer);
      }
      await dio.post('/question', data: {
        "categoryId": selectedCategory,
        "question": questionTitleC.text,
        "level": selectedLevel,
        "createdBy": userId,
        "posibleAnswers": answerList
      }).then((response) {
        if (response.statusCode == 200) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: AppTheme.success,
            content: Text("additionSuccessful").tr(),
          ));
          setState(() {
            isProcessing = false;
            questionTitleC.text = '';
//            selectedLevel = null;
//            selectedAnswer = null;
            for (int i = 0; i < labelControllersList.length; i++) {
              labelControllersList[i]['labelController$i'].text = '';
              labelValueControllersList[i]['labelValueController$i'].text = '';
            }
          });
        }
      }).catchError((error) {
        setState(() {
          isProcessing = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: AppTheme.success,
          content: Text("somethingWentWrongTryAgain").tr(),
        ));
      });
    });
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    userId = userInfo.get("userId");
  }
}

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
