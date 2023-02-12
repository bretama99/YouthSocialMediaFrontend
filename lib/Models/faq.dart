import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class FAQ {
  int _faqId;
  String _title;
  String _answer;
  String _createdBy;
  String _createdAt;

  //****************FAQ Table*********************//
  String faqTable = 'faqTable';
  String colFaqId = 'faqId';
  String colTitle = 'title';
  String colAnswer = 'answer';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';

  //**********************End******************************//

  FAQ.empty();

  FAQ(this._title, this._answer, this._createdBy, this._createdAt);

  FAQ.withId(this._faqId, this._answer, this._title, [this._createdAt]);

  int get faqId => _faqId;

  String get title => _title;

  String get answer => _answer;

  String get createdBy => _createdBy;

  String get createdAt => _createdAt;

  set faqId(int faqId) {
    this._faqId = faqId;
  }

  set title(String title) {
    this._title = title;
  }

  set answer(String answer) {
    this._title = answer;
  }

  set createdBy(String createdBy) {
    this._createdBy = createdBy;
  }

  set createdAt(String createdAt) {
    this._createdAt = createdAt;
  }

  // Convert a Category object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (faqId != null) {
      map['faqId'] = _faqId;
    }
    map['title'] = _title;
    map['answer'] = _answer;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;

    return map;
  }

  // Extract a Category object from a Map object
  FAQ.fromMapObject(Map<String, dynamic> map) {
    this._faqId = map['faqId'];
    this._title = map['title'];
    this._answer = map['answer'];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
  }

  DatabaseHelper databaseHelper = DatabaseHelper();

  ///////****************************FAQ Query Functions****************************************////////

  // Fetch Operation: Get all objects from database
  Future<List<Map<String, dynamic>>> getFAQMapList() async {
    Database db = await databaseHelper.database;
    var result = await db.query(faqTable, orderBy: '$colFaqId ASC');
    return result;
  }

  // Insert Operation: Insert object to database
  Future<int> insertFAQ(FAQ faq) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(faqTable, faq.toMap());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateFAQ(FAQ faq) async {
    var db = await databaseHelper.database;
    var result = await db.update(faqTable, faq.toMap(),
        where: '$colFaqId = ?', whereArgs: [faq.faqId]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteFAQ(int id) async {
    var db = await databaseHelper.database;
    int result =
        await db.rawDelete('DELETE FROM $faqTable WHERE $colFaqId = $id');
    return result;
  }

  // Get number of objects in database
  Future<int> getFAQCount() async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $faqTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Obj List' [ List<Obj> ]
  Future<List<FAQ>> getFAQList() async {
    var faqMapList = await getFAQMapList(); // Get 'Map List' from database
    int count =
        faqMapList.length; // Count the number of map entries in db table

    List<FAQ> faqList = List<FAQ>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      faqList.add(FAQ.fromMapObject(faqMapList[i]));
    }

    return faqList;
  }

  Future<FAQ> getSingleFAQ(int id) async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> faqMap =
        await db.rawQuery('SELECT * FROM $faqTable WHERE $colFaqId = $id');
    var singleFAQ;
    if (faqMap.isNotEmpty) {
      singleFAQ = FAQ.fromMapObject(faqMap[0]);
    }

    return singleFAQ;
  }

  void removeDeletedRows(List<FAQ> list) async {
    List<FAQ> cached = await getFAQList();
    List<int> notDeletedList = [];
    int notInFetchedMismatchCount;
    List<int> deletedList = [];
    cached.forEach((element) {
      notInFetchedMismatchCount = 0;
      for (int i = 0; i < list.length; i++) {
        if (element.faqId == list[i].faqId) {
          notDeletedList.add(element.faqId);
        } else {
          ++notInFetchedMismatchCount;
          //if mismatch has reached to the number of items in the fetched one the item doesn't exist
          if ((notInFetchedMismatchCount) == list.length) {
            deletedList.add(element.faqId);
          }
        }
      }
    });

    //delete query for the removed ones
    deletedList.forEach((id) {
      deleteFAQ(id);
    });
  }

///////////////////********************End**********************///////////////////////////
}
