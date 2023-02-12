import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class PossibleAnswer {
  int _posibleAnswerId;
  int _questionId;
  String _label;
  String _labelValue;
  String _createdAt;
  String _createdBy;
  int _isAnswer;

  // ****************Options Table*********************//
  String optionTable = 'optionTable';
  String colOptionId = 'posibleAnswerId';
  String colQuestionId = 'questionId';
  String colLabel = 'label';
  String colLabelValue = 'labelValue';
  String colIsAnswer = 'isAnswer';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';

  //**********************End******************************//

  //empty constructor
  PossibleAnswer.empty();

  //[] indicates optional parameters
  PossibleAnswer(this._label, this._questionId, this._labelValue,
      this._isAnswer, this._createdBy,
      [this._createdAt]);

  PossibleAnswer.withId(this._posibleAnswerId, this._questionId, this._label,
      this._isAnswer, this._createdBy,
      [this._createdAt]);

  int get posibleAnswerId => _posibleAnswerId;

  int get questionId => _questionId;

  String get label => _label;

  String get labelValue => _labelValue;

  int get isAnswer => _isAnswer;

  String get createdBy => _createdBy;

  String get createdAt => _createdAt;

  set label(String label) {
    this._label = label;
  }

  set posibleAnswerId(int posibleAnswerId) {
    this._posibleAnswerId = posibleAnswerId;
  }

  set questionId(int questionId) {
    this._questionId = questionId;
  }

  set labelValue(String labelValue) {
    this._labelValue = labelValue;
  }

  set isAnswer(int isAnswer) {
    this._isAnswer = isAnswer;
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
    if (posibleAnswerId != null) {
      map['posibleAnswerId'] = _posibleAnswerId;
    }
    map['label'] = _label;
    map['questionId'] = _questionId;
    map['labelValue'] = _labelValue;
    map['isAnswer'] = _isAnswer;
    map['createdAt'] = _createdAt;
    map['createdBy'] = _createdBy;

    return map;
  }

  // Extract a Category object from a Map object
  PossibleAnswer.fromMapObject(Map<String, dynamic> map) {
    this._posibleAnswerId = map['posibleAnswerId'];
    this._questionId = map['questionId'];
    this._label = map['label'];
    this._labelValue = map['labelValue'];
    this._isAnswer = map['isAnswer'];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
  }

  ///////****************************Option Functions****************************************////////
  DatabaseHelper databaseHelper = DatabaseHelper();

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getOptionMapList() async {
    Database db = await databaseHelper.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(optionTable, orderBy: '$colOptionId ASC');
    return result;
  }

  // Insert Operation: Insert a Obj object to database
  Future<int> insertOption(PossibleAnswer optionEntity) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(optionTable, optionEntity.toMap());
    return result;
  }

  // Update Operation: Update a Obj object and save it to database
  Future<int> updateOption(PossibleAnswer optionEntity) async {
    var db = await databaseHelper.database;
    var result = await db.update(optionTable, optionEntity.toMap(),
        where: '$colOptionId = ?', whereArgs: [optionEntity.posibleAnswerId]);
    return result;
  }

  // Delete Operation: Delete a Obj object from database
  Future<int> deleteOption(int id) async {
    var db = await databaseHelper.database;
    int result =
        await db.rawDelete('DELETE FROM $optionTable WHERE $colOptionId = $id');
    return result;
  }

  // Get number of Obj objects in database
  Future<int> getOptionCount() async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $optionTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Obj List' [ List<Obj> ]
  Future<List<PossibleAnswer>> getOptionList() async {
    var optionMapList =
        await getOptionMapList(); // Get 'Map List' from database
    int count =
        optionMapList.length; // Count the number of map entries in db table

    List<PossibleAnswer> optionList = List<PossibleAnswer>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      optionList.add(PossibleAnswer.fromMapObject(optionMapList[i]));
    }

    return optionList;
  }

  Future<PossibleAnswer> getSingleAnswer(int id) async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> answerMap = await db
        .rawQuery('SELECT * FROM $optionTable WHERE $colOptionId = $id');
    var singleAnswer;
    if (answerMap.isNotEmpty) {
      singleAnswer = PossibleAnswer.fromMapObject(answerMap[0]);
    }

    return singleAnswer;
  }

  void removeDeletedRows(List<PossibleAnswer> list) async {
    List<PossibleAnswer> cached = await getOptionList();
    List<int> notDeletedList = [];
    int notInFetchedMismatchCount;
    List<int> deletedList = [];
    if (cached != null && list != null) {
      cached.forEach((element) {
        notInFetchedMismatchCount = 0;
        for (int i = 0; i < list.length; i++) {
          if (element.posibleAnswerId == list[i].posibleAnswerId) {
            notDeletedList.add(element.posibleAnswerId);
          } else {
            ++notInFetchedMismatchCount;
            //if mismatch has reached to the number of items in the fetched one the item doesn't exist
            if ((notInFetchedMismatchCount) == list.length) {
              deletedList.add(element.posibleAnswerId);
            }
          }
        }
      });

      //delete query for the removed ones
      deletedList.forEach((id) {
        deleteOption(id);
      });
    }
  }

  Future<List<PossibleAnswer>> getPossibleAnswerList(int questionId) async {
    Database db = await databaseHelper.database;
    var result = await db.rawQuery(
        'SELECT * FROM $optionTable WHERE $colQuestionId = $questionId order by $colOptionId ASC');
    var count = result.length;

    List<PossibleAnswer> optionList = List<PossibleAnswer>();
    for (int i = 0; i < count; i++) {
      optionList.add(PossibleAnswer.fromMapObject(result[i]));
    }

    return optionList;
  }

///////////////////********************End**********************///////////////////////////

}
