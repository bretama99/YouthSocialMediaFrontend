import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class HealthInstitution {
  int _institutionId;
  String _institutionName;
  String _createdBy;
  String _createdAt;

  String _category;
  String _latitude;
  String _longitude;
  String _address;

  //****************Request Table*********************//
  String institutionTable = 'institutionTable';
  String colInstitutionId = 'healthInstitutionId';
  String colInstitutionName = 'institutionName';
  String colCategory = 'category';
  String colLatitude = 'latitude';
  String colLongitude = 'longitude';
  String colAddress = 'address';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';

  //**********************End******************************//

  HealthInstitution.empty();

  HealthInstitution(this._institutionName, this._category, this._latitude,
      this._longitude, this._address, this._createdBy, this._createdAt);

  HealthInstitution.withId(this._institutionId, this._institutionName,
      this._category, this._latitude, this._longitude, this._address,
      [this._createdAt]);

  int get institutionId => _institutionId;

  String get category => _category;

  String get institutionName => _institutionName;

  String get latitude => _latitude;

  String get longitude => _longitude;

  String get address => _address;

  String get createdBy => _createdBy;

  String get createdAt => _createdAt;

  set institutionId(int institutionId) {
    this._institutionId = institutionId;
  }

  set category(String category) {
    this._category = category;
  }

  set institutionName(String institutionName) {
    this._institutionName = institutionName;
  }

  set latitude(String latitude) {
    this._latitude = latitude;
  }

  set longitude(String longitude) {
    this._longitude = longitude;
  }

  set address(String address) {
    this._address = address;
  }

  set createdBy(String createdBy) {
    this._createdBy = createdBy;
  }

  set createdAt(String createdAt) {
    this._createdAt = createdAt;
  }

  // Convert a object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (institutionId != null) {
      map['healthInstitutionId'] = _institutionId;
    }
    map['category'] = _category;
    map['institutionName'] = _institutionName;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['address'] = _address;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;

    return map;
  }

  // Extract a Category object from a Map object
  HealthInstitution.fromMapObject(Map<String, dynamic> map) {
    this._institutionId = map['healthInstitutionId'];
    this._category = map['category'];
    this._institutionName = map['institutionName'];
    this._latitude = map['latitude'].toString();
    this._longitude = map['longitude'].toString();
    this._address = map['address'];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
  }

  ///////****************************Health Institution Query Functions****************************************////////
  DatabaseHelper databaseHelper = DatabaseHelper();

  // Fetch Operation: Get all objects from database
  Future<List<Map<String, dynamic>>> getInstitutionMapList() async {
    Database db = await databaseHelper.database;
    var result =
        await db.query(institutionTable, orderBy: '$colInstitutionId ASC');
    return result;
  }

  // Insert Operation: Insert object to database
  Future<int> insertInstitution(HealthInstitution request) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(institutionTable, request.toMap());
    print(result);
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateInstitution(HealthInstitution request) async {
    var db = await databaseHelper.database;
    var result = await db.update(institutionTable, request.toMap(),
        where: '$colInstitutionId = ?', whereArgs: [request.institutionId]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteInstitution(int id) async {
    var db = await databaseHelper.database;
    int result = await db.rawDelete(
        'DELETE FROM $institutionTable WHERE $colInstitutionId = $id');
    return result;
  }

  // Get number of objects in database
  Future<int> getInstitutionCount() async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $institutionTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Obj List' [ List<Obj> ]
  Future<List<HealthInstitution>> getInstitutionList() async {
    var institutionMapList = await getInstitutionMapList(); // Get 'Map List' from database
    int count = institutionMapList.length; // Count the number of map entries in db table

    List<HealthInstitution> institutionList = List<HealthInstitution>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      institutionList
          .add(HealthInstitution.fromMapObject(institutionMapList[i]));
    }
    return institutionList;
  }
  Future<List<HealthInstitution>> queryAllRows() async {
    List<HealthInstitution> fetchedData = [];
    int j = 0;
    await dio.get('/health_institution').then((response) {
      print(response.data);
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singlePost = HealthInstitution.fromMapObject(response.data[i]);
          fetchedData.add(singlePost);
        }
      }
    });
    print(fetchedData);
    return fetchedData;
  }
      Future<HealthInstitution> getSingleInstitution(int id) async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> healthInstitutionMap = await db.rawQuery(
        'SELECT * FROM $institutionTable WHERE $colInstitutionId = $id');
    var singleInstituion;
    if (healthInstitutionMap.isNotEmpty) {
      singleInstituion =
          HealthInstitution.fromMapObject(healthInstitutionMap[0]);
    }

    return singleInstituion;
  }


  void removeDeletedRows(List<HealthInstitution> list) async {
    List<HealthInstitution> cached = await getInstitutionList();
    List<int> notDeletedList = [];
    int notInFetchedMismatchCount;
    List<int> deletedList = [];
    cached.forEach((element) {
      notInFetchedMismatchCount = 0;
      for (int i = 0; i < list.length; i++) {
        if (element.institutionId == list[i].institutionId) {
          notDeletedList.add(element.institutionId);
        } else {
          ++notInFetchedMismatchCount;
          //if mismatch has reached to the number of items in the fetched one the item doesn't exist
          if ((notInFetchedMismatchCount) == list.length) {
            deletedList.add(element.institutionId);
          }
        }
      }
    });

    //delete query for the removed ones
    deletedList.forEach((id) {
      deleteInstitution(id);
    });

  }

///////////////////********************End**********************///////////////////////////
}
