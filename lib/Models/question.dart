import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Models/possible_answers.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

import 'question_option_entity.dart';

class Question {
  int _questionId;
  int _categoryId;
  String _question;
  String _level;
  String _createdAt;
  String _createdBy;
  List<PossibleAnswer> _posibleAnswers;

  //****************Question Table*********************//
  String questionTable = 'questionTable';
  String colQuestionId = 'questionId';
  String colQuestion = 'question';
  String colLevel = 'level';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';

  //**********************End******************************//

  Question.empty();

  Question(this._question, this._categoryId, this._level, this._createdBy,
      [this._createdAt]);

  Question.withId(
      this._questionId, this._categoryId, this._question, this._createdBy,
      [this._createdAt]);

  int get questionId => _questionId;

  int get categoryId => _categoryId;

  String get question => _question;

  String get level => _level;

  String get createdBy => _createdBy;

  String get createdAt => _createdAt;

  List<PossibleAnswer> get posibleAnswers => _posibleAnswers;

  set question(String question) {
    this._question = question;
  }

  set posibleAnswers(List posibleAnswers) {
    this._posibleAnswers = posibleAnswers;
  }

  set categoryId(int categoryId) {
    this._categoryId = categoryId;
  }

  set level(String level) {
    this._level = level;
  }

  set createdAt(String createdAt) {
    this._createdAt = createdAt;
  }

  set createdBy(String createdBy) {
    this._createdBy = createdBy;
  }

  // Convert a Category object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (questionId != null) {
      map['questionId'] = _questionId;
    }
    map['question'] = _question;
    map['categoryId'] = _categoryId;
    map['level'] = _level;
    map['createdAt'] = _createdAt;
    map['createdBy'] = _createdBy;

    return map;
  }

  // Extract a Category object from a Map object
  Question.fromMapObject(Map<String, dynamic> map) {
    this._questionId = map['questionId'];
    this._categoryId = map['categoryId'];
    this._question = map['question'];
    this._level = map['level'];
//    this._posibleAnswers = map["posibleAnswers"];
    this._posibleAnswers = map["posibleAnswers"] != null
        ? List<PossibleAnswer>.from(
            map["posibleAnswers"].map((x) => PossibleAnswer.fromMapObject(x)))
        : [];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
  }

  ///////****************************Question Functions****************************************////////

  DatabaseHelper databaseHelper = DatabaseHelper();
  final _random = new Random();
  PossibleAnswer possibleAnswer = new PossibleAnswer.empty();

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getQuestionMapList(
      int categoryId, String level) async {
    Database db = await databaseHelper.database;
    var result;
    if (categoryId != 0 && level != 'Any') {
      result = await db.rawQuery(
          'SELECT * FROM $questionTable WHERE categoryId = $categoryId AND $colLevel = "$level"  order by $colQuestionId ASC');
    } else if (categoryId == 0 && level != 'Any') {
      result = await db.rawQuery(
          'SELECT * FROM $questionTable WHERE $colLevel = "$level"  order by $colQuestionId ASC');
    } else if (categoryId != 0 && level == 'Any') {
      result = await db.rawQuery(
          'SELECT * FROM $questionTable WHERE categoryId = $categoryId  order by $colQuestionId ASC');
    } else {
      result = await db
          .rawQuery('SELECT * FROM $questionTable order by $colQuestionId ASC');
    }
//    var result = await db.query(questionTable, orderBy: '$colQuestionId ASC');
    return result;
  }

  // Insert Operation: Insert a Obj  to database
  Future<int> insertQuestion(Question questionEntity) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(questionTable, questionEntity.toMap());
    return result;
  }

  // Update Operation: Update a Obj  and save it to database
  Future<int> updateQuestion(Question questionEntity) async {
    var db = await databaseHelper.database;
    var result = await db.update(questionTable, questionEntity.toMap(),
        where: '$colQuestionId = ?', whereArgs: [questionEntity.questionId]);
    return result;
  }

  // Delete Operation: Delete a Obj  from database
  Future<int> deleteQuestion(int id) async {
    var db = await databaseHelper.database;
    int result = await db
        .rawDelete('DELETE FROM $questionTable WHERE $colQuestionId = $id');
    return result;
  }

  // Get number of Obj  in database
  Future<int> getQuestionCount() async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $questionTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Obj List' [ List<Obj> ]
  Future<List<Question>> getQuestionList(int categoryId, String level) async {
    var questionMapList = await getQuestionMapList(
        categoryId, level); // Get 'Map List' from database
    int count =
        questionMapList.length; // Count the number of map entries in db table

    List<Question> questionList = List<Question>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      questionList.add(Question.fromMapObject(questionMapList[i]));
    }

    return questionList;
  }
  Future<List<QuestionOptionEntity>> getSingleQuestionWithItsOptions(
      int questionId, int questionLength, String level) async {
    Database db = await databaseHelper.database;
    List<QuestionOptionEntity> allQuestions = [];

    var result = await db.rawQuery(
        'SELECT * FROM $questionTable INNER JOIN'
            ' ${possibleAnswer.optionTable} on '
            '${possibleAnswer.optionTable}.$colQuestionId = $questionTable.$colQuestionId where $questionTable.$colQuestionId=$questionId and $questionTable.$colLevel = $level ');
    for (int i = 0; i < result.length; i++) {
//      print(result[i]);
      allQuestions.add(QuestionOptionEntity.fromMapObject(result[i]));
    }
    var randomIndices = [];
    for (int i = 0; i < questionLength; i++) {
      int generated = 0;
      generated = rand(allQuestions.length, 0);
      randomIndices.add(generated);
    }

    return allQuestions;
  }

  //random int generator
  int rand(int max, int min) => min + _random.nextInt(max - min);

  Future<List<List<QuestionOptionEntity>>> getQuestions(
      int categoryId, int questionLength, String level) async {
    Database db = await databaseHelper.database;
    List<QuestionOptionEntity> allQuestions = [];
    //list of question with option arranged with there according question
    List<List<QuestionOptionEntity>> allQuestionsArranged = [];
    var allFilteredQuestions;
    if (level == 'Any')
      allFilteredQuestions = await db.rawQuery(
          'SELECT * FROM $questionTable INNER JOIN ${possibleAnswer.optionTable} on ${possibleAnswer.optionTable}.$colQuestionId = $questionTable.$colQuestionId WHERE $questionTable.categoryId = $categoryId');
    else
      allFilteredQuestions = await db.rawQuery(
          'SELECT * FROM $questionTable INNER JOIN ${possibleAnswer.optionTable} on ${possibleAnswer.optionTable}.$colQuestionId = $questionTable.$colQuestionId WHERE $questionTable.categoryId = $categoryId AND $questionTable.$colLevel = "$level" ');
    for (int i = 0; i < allFilteredQuestions.length; i++) {
      allQuestions
          .add(QuestionOptionEntity.fromMapObject(allFilteredQuestions[i]));
    }

    if (allFilteredQuestions.isNotEmpty) {
      List<int> questionIdList = [];
      Future<List<Question>> listOfQuestion =
          getQuestionList(categoryId, level);
      listOfQuestion.then((questionsList) {
        questionsList.forEach((element) {
          questionIdList.add(element.questionId);
        });

        for (int i = 0; i < questionIdList.length; i++) {
          List<QuestionOptionEntity> oneQuestion = [];
          for (int j = 0; j < allQuestions.length; j++) {
            if (questionIdList[i] == allQuestions[j].questionId) {
              oneQuestion.add(allQuestions[j]);
            }
          }
          if (oneQuestion.isNotEmpty) allQuestionsArranged.add(oneQuestion);
        }
      });
    }

    return allQuestionsArranged;
  }

  Future<Question> getSingleQuestion(int id) async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> questionMap = await db
        .rawQuery('SELECT * FROM $questionTable WHERE $colQuestionId = $id');
    var singleQuestion;
    if (questionMap.isNotEmpty) {
      singleQuestion = Question.fromMapObject(questionMap[0]);
    }

    return singleQuestion;
  }

  void removeDeletedRows(List<Question> list) async {
    List<Question> cached = await getQuestionList(0, 'Any');
    List<int> notDeletedList = [];
    int notInFetchedMismatchCount;
    List<int> deletedList = [];
    if (cached != null && list != null) {
      cached.forEach((element) {
        notInFetchedMismatchCount = 0;
        for (int i = 0; i < list.length; i++) {
          if (element.questionId == list[i].questionId) {
            notDeletedList.add(element.questionId);
          } else {
            ++notInFetchedMismatchCount;
            //if mismatch has reached to the number of items in the fetched one the item doesn't exist
            if ((notInFetchedMismatchCount) == list.length) {
              deletedList.add(element.questionId);
            }
          }
        }
      });

      //delete query for the removed ones
      deletedList.forEach((id) {
        deleteQuestion(id);
      });
    }
  }

  Future<List<Question>> queryQuestions(int categoryId, int questionLength, String level) async {
    var questionMapList = await getQuestionMapList(categoryId, level);
    int count = questionMapList.length;

    List<Question> questionList = List<Question>();

    for (int i = 0; i < count; i++) {
      questionList.add(Question.fromMapObject(questionMapList[i]));
      Future<List<PossibleAnswer>> possibleAnswerList =
          possibleAnswer.getPossibleAnswerList(questionList[i].questionId);

      possibleAnswerList.then(
        (itemList) {
          questionList[i].posibleAnswers = itemList;
        },
      );
    }
    return questionList;
  }

///////////////////********************End**********************///////////////////////////

}
