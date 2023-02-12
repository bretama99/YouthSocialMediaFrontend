import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class RequestChat {
  int _requestChatId;
  String _message;
  String _createdBy;
  DateTime _createdAt;

  int _requestId;
  String _profilePicture;
  String _healthFacility;
  String _image;



  //****************Request Table*********************//
  String requestTable = 'requestTable';
  String colRequestId = 'requestId';
  String colCategoryId = 'categoryId';
  String colRequestDetail = 'requestDetail';
  String colLatitude = 'latitude';
  String colLongitude = 'longitude';
  String colStatus = 'status';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';
  //**********************End******************************//


  RequestChat.empty();
  RequestChat(this._message,this._requestId,this._profilePicture,this._healthFacility,this._image,this._createdBy, [this._createdAt]);

  RequestChat.withId(this._requestChatId, this._message,this._requestId,this._profilePicture,this._healthFacility,this._image, [this._createdAt]);

  int get requestChatId => _requestChatId;

  int get requestId => _requestId;

  String get message => _message;

  String get image => _image;

  String get profilePicture => _profilePicture;

  String get healthFacility => _healthFacility;


  String get createdBy => _createdBy;

  DateTime get createdAt => _createdAt;


  set requestChatId (int requestChatId) {
    this._requestChatId = requestChatId;
  }
  set requestId (int requestId) {
    this._requestId = requestId;
  }

  set message(String message) {
    this._message = message;
  }
  set profilePicture(String profilePicture) {
    this._profilePicture = profilePicture;
  }
  set healthFacility(String healthFacility) {
    this._healthFacility = healthFacility;
  }
  set image(String image) {
    this._image = image;
  }

  set createdBy(String createdBy) {
    this._createdBy = createdBy;
  }

  set createdAt(DateTime createdAt) {
    this._createdAt = createdAt;
  }

  // Convert a Category object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (requestId != null) {
      map['requestChatId'] = _requestChatId;
    }
    map['requestId'] = _requestId;
    map['message'] = _message;
    map['profilePicture'] = _profilePicture;
    map['healthFacility'] = _healthFacility;
    map['image'] = _image;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;

    return map;
  }

  // Extract a Category object from a Map object
  RequestChat.fromMapObject(Map<String, dynamic> map) {
    this._requestChatId = map['assistanceRequestId'];
    this._requestId = map['requestId'];
    this._message = map['message'];
    this._profilePicture = map['profilePicture'];
    this._healthFacility = map['healthFacility'];
    this._image = map['image'];
    this._createdBy = map['createdBy'];
    this._createdAt = DateTime.parse(map['createdAt']);
  }






  ///////****************************Category Query Functions****************************************////////
  DatabaseHelper databaseHelper = DatabaseHelper();

  // Fetch Operation: Get all objects from database
  Future<List<Map<String, dynamic>>> getRequestMapList() async {
    Database db = await databaseHelper.database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(requestTable, orderBy: '$colRequestId ASC');
    return result;
  }

  // Insert Operation: Insert object to database
  Future<int> insertRequest(RequestChat request) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(requestTable, request.toMap());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateRequest(RequestChat request) async {
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
  Future<List<RequestChat>> getRequestList() async {
    var requestMapList =
    await getRequestMapList(); // Get 'Map List' from database
    int count =
        requestMapList.length; // Count the number of map entries in db table

    List<RequestChat> requestList = List<RequestChat>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      requestList.add(RequestChat.fromMapObject(requestMapList[i]));
    }
    return requestList;
  }

  // Get closed requests
  Future<List<RequestChat>> getClosedRequestList() async {
    var db = await databaseHelper.database;
    var getAllClosedRequests = await db
        .rawQuery('SELECT * FROM $requestTable WHERE $colStatus =  "Closed"');
    int count =
        getAllClosedRequests.length;

    List<RequestChat> requestList = List<RequestChat>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      requestList.add(RequestChat.fromMapObject(getAllClosedRequests[i]));
    }
    return requestList;
  }

  // Get active requests
  Future<List<RequestChat>> getActiveRequestList() async {
    var db = await databaseHelper.database;
    var getAllClosedRequests = await db
        .rawQuery('SELECT * FROM $requestTable WHERE $colStatus =  "Active"');
    int count =
        getAllClosedRequests.length;

    List<RequestChat> requestList = List<RequestChat>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      requestList.add(RequestChat.fromMapObject(getAllClosedRequests[i]));
    }
    return requestList;
  }

///////////////////********************End**********************///////////////////////////
}
