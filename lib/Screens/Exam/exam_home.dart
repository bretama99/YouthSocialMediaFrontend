import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Models/possible_answers.dart';
import 'package:youth_and_adolesence/Models/question.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';
import 'exam_options.dart';

class ExamHomePage extends StatefulWidget {
  @override
  _ExamHomePageState createState() => _ExamHomePageState();
}

class _ExamHomePageState extends State<ExamHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Category category = new Category.empty();
  Question question = new Question.empty();
  PossibleAnswer possibleAnswer = new PossibleAnswer.empty();
  List<Category> categoryList = [];
  int count = 0;
  Future<List<Category>> list;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  bool isFetching = false;
  bool isEmpty = false;

  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

  @override
  void initState() {
    super.initState();
//    getCategory();
    fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('questionAndAnswers').tr(),
          centerTitle: true,
          actions: <Widget>[
            Container(
//              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 2),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 2),
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.black54,
                icon: Icon(
                  Icons.refresh,
                  color: AppTheme.white,
                ),
                onPressed: fetchQuestions,
                label: Text(
                  'sync',
                  style: TextStyle(color: AppTheme.white),
                ).tr(),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            buildCustomScrollView(),
          ],
        ));
  }

  Widget buildCustomScrollView() {
    if (!isFetching && !isEmpty) {
      return CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Center(
                child: Text(
                  "selectToStartQuiz".tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0),
                delegate: SliverChildBuilderDelegate(
                  _buildCategoryItem,
                  childCount: categoryList.length,
                )),
          ),
        ],
      );
    } else if (isFetching && !isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDoubleBounce(
              color: Colors.black54,
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

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categoryList[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade900,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.globeAsia),
//          if(category.icon != null)
//            Icon(category.icon),
//          if(category.icon != null)
//            SizedBox(height: 5.0),
          Text(
            category.categoryName,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => ExamOptionsDialog(
          category: category,
        ),
        onClosing: () {},
      ),
    );
  }

  void getCategory() {
    Future<List<Category>> categoryListFuture = category.getCategoryList();
    categoryListFuture.then((categoryList) {
      setState(() {
        this.categoryList = categoryList;
        this.count = categoryList.length;
      });
    });
  }

  Future fetchCategory() {
    setState(() {
      isFetching = true;
      isEmpty = false;
    });
    Future<Response> res = dio.get('/category');
    List<Category> fetchedList = [];
    res.then((response) async {
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singleCategory = Category.fromMapObject(response.data[i]);
          fetchedList.add(singleCategory);
          //update or insert
          Category cached =
              await category.getSingleCategory(singleCategory.categoryId);
          if (cached != null) {
            category.updateCategory(singleCategory);
          } else {
            category.insertCategory(singleCategory);
          }
        }

        //remove deleted tuples
        category.removeDeletedRows(fetchedList);

        setState(() {
          fetchedList.isNotEmpty ? isEmpty = false : isEmpty = true;
          isFetching = false;
        });
      }
      return getCategory();
    });

    res.catchError((error) {
      setState(() {
        isFetching = false;
        isEmpty = false;
      });
      getCategory();
    });

    return res;
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
