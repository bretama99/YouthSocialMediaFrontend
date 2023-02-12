import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class UserAssistanceRequest {
  int _requestId;
  String _requestDetail;

//  String _createdBy;
  String _createdAt;

//  int _categoryId;
  String _categoryName;

//  String _profilePicture;
  String _latitude;
  String _longitude;
  String _status;

  //****************Request Table*********************//
  String requestTable = 'requestTable';
  String colRequestId = 'assistanceRequestId';
  String colCategoryId = 'categoryId';
  String colCategory = 'category';
  String colProfilePicture = 'profilePicture';
  String colRequestDetail = 'requestDetail';
  String colLatitude = 'latitude';
  String colLongitude = 'longitude';
  String colStatus = 'status';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';

  //**********************End******************************//

  UserAssistanceRequest.empty();

  UserAssistanceRequest(this._requestDetail, this._categoryName, this._latitude,
      this._longitude, this._status,
      [this._createdAt]);

  UserAssistanceRequest.withId(this._requestId, this._requestDetail,
      this._latitude, this._longitude, this._status,
      [this._createdAt]);

  int get requestId => _requestId;

//  int get categoryId => _categoryId;

  String get requestDetail => _requestDetail;

  String get latitude => _latitude;

  String get categoryName => _categoryName;

//  String get profilePicture => _profilePicture;

  String get longitude => _longitude;

  String get status => _status;

//  String get createdBy => _createdBy;

  String get createdAt => _createdAt;

  set requestId(int requestId) {
    this._requestId = requestId;
  }

//  set categoryId(int categoryId) {
//    this._categoryId = categoryId;
//  }

  set requestDetail(String requestDetail) {
    this._requestDetail = requestDetail;
  }

  set categoryName(String categoryName) {
    this._categoryName = categoryName;
  }

//  set profilePicture(String profilePicture) {
//    this._profilePicture = profilePicture;
//  }

  set latitude(String latitude) {
    this._latitude = latitude;
  }

  set longitude(String longitude) {
    this._longitude = longitude;
  }

  set status(String status) {
    this._status = status;
  }

//  set createdBy(String createdBy) {
//    this._createdBy = createdBy;
//  }

  set createdAt(String createdAt) {
    this._createdAt = createdAt;
  }

  // Convert a Category object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (requestId != null) {
      map['assistanceRequestId'] = _requestId;
    }
    map['requestDetail'] = _requestDetail;
    map['category'] = _categoryName;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
//    map['createdBy'] = _createdBy;
//    map['categoryId'] = _categoryId;
//    map['profilePicture'] = _profilePicture;

    return map;
  }

  // Extract a Category object from a Map object
  UserAssistanceRequest.fromMapObject(Map<String, dynamic> map) {
    this._requestId = map['assistanceRequestId'];
    this._requestDetail = map['requestDetail'];
    this._categoryName = map['category'];
    this._latitude = map['latitude'].toString();
    this._longitude = map['longitude'].toString();
    this._status = map['status'];
    this._createdAt = map['createdAt'];
//    this._profilePicture = map['profilePicture'];
//    this._categoryId = map['categoryId'];
//    this._createdBy = map['createdBy'];
  }

  ///////****************************Assistance Query Functions****************************************////////
  DatabaseHelper databaseHelper = DatabaseHelper();

  // Fetch Operation: Get all objects from database
  Future<List<Map<String, dynamic>>> getRequestMapList() async {
    Database db = await databaseHelper.database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(requestTable, orderBy: '$colRequestId ASC');

    return result;
  }

  // Insert Operation: Insert object to database
  Future<int> insertRequest(UserAssistanceRequest request) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(requestTable, request.toMap());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateRequest(UserAssistanceRequest request) async {
    var db = await databaseHelper.database;
    var result = await db.update(requestTable, request.toMap(),
        where: '$colRequestId = ?', whereArgs: [request.requestId]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteRequest(int id) async {
    var db = await databaseHelper.database;
    int result = await db
        .rawDelete('DELETE FROM $requestTable WHERE $colRequestId = $id');
    return result;
  }

  // Get number of objects in database
  Future<int> getRequestCount() async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $requestTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Obj List' [ List<Obj> ]
  Future<List<UserAssistanceRequest>> getRequestList() async {
    var requestMapList =
        await getRequestMapList(); // Get 'Map List' from database
    int count =
        requestMapList.length; // Count the number of map entries in db table

    List<UserAssistanceRequest> requestList = List<UserAssistanceRequest>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      requestList.add(UserAssistanceRequest.fromMapObject(requestMapList[i]));
    }
    return requestList;
  }

  // Get closed requests
  Future<List<UserAssistanceRequest>> getClosedRequestList() async {
    var db = await databaseHelper.database;
    var getAllClosedRequests = await db
        .rawQuery('SELECT * FROM $requestTable WHERE $colStatus =  "closed"');
    int count = getAllClosedRequests.length;

    List<UserAssistanceRequest> requestList = List<UserAssistanceRequest>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      requestList
          .add(UserAssistanceRequest.fromMapObject(getAllClosedRequests[i]));
    }
    return requestList;
  }

  // Get active requests
  Future<List<UserAssistanceRequest>> getActiveRequestList() async {
    var db = await databaseHelper.database;
    var getAllClosedRequests = await db
        .rawQuery('SELECT * FROM $requestTable WHERE $colStatus =  "active"');
    int count = getAllClosedRequests.length;

    List<UserAssistanceRequest> requestList = List<UserAssistanceRequest>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      requestList
          .add(UserAssistanceRequest.fromMapObject(getAllClosedRequests[i]));
    }
    return requestList;
  }

  Future<UserAssistanceRequest> getSingleAssistanceRequest(int id) async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> requestMap = await db
        .rawQuery('SELECT * FROM $requestTable WHERE $colRequestId = $id');
    var singleRequest;
    if (requestMap.isNotEmpty) {
      singleRequest = UserAssistanceRequest.fromMapObject(requestMap[0]);
    }

    return singleRequest;
  }

  void removeDeletedRows(List<UserAssistanceRequest> list) async {
    List<UserAssistanceRequest> cached = await getRequestList();
    List<int> notDeletedList = [];
    int notInFetchedMismatchCount;
    List<int> deletedList = [];
    cached.forEach((element) {
      notInFetchedMismatchCount = 0;
      for (int i = 0; i < list.length; i++) {
        if (element.requestId == list[i].requestId) {
          notDeletedList.add(element.requestId);
        } else {
          ++notInFetchedMismatchCount;
          //if mismatch has reached to the number of items in the fetched one the item doesn't exist
          if ((notInFetchedMismatchCount) == list.length) {
            deletedList.add(element.requestId);
          }
        }
      }
    });

    //delete query for the removed ones
    deletedList.forEach((id) {
      deleteRequest(id);
    });
  }

///////////////////********************End**********************///////////////////////////
}
