import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class Post {
  int _postId;
  String _postDetail;
  String _createdBy;
  String _createdAt;

  String _postImage;
  int _likes;
  int _categoryId;
  int _reports;
  int _isDeleted;



  //****************Post Table*********************//
  String postTable = 'postTable';
  String colPostId = 'postId';
  String colCategoryId = 'categoryId';
  String colPostDetail = 'postDetail';
  String colPostImage = 'postImage';
  String colLikes = 'likes';
  String colReports = 'reports';
  String colIsDeleted = 'isDeleted';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';

  //**********************End******************************//




  //constructors
  Post.empty();
  Post(this._categoryId,this._postDetail,this._postImage,this._likes,this._reports, this._isDeleted,this._createdBy,this._createdAt);

  Post.withId(this._postId,this._categoryId,this._postDetail,this._postImage,this._likes,this._reports, this._isDeleted, [this._createdAt]);



  //getters
  int get postId => _postId;

  int get categoryId => _categoryId;

  int get likes => _likes;

  int get reports => _reports;

  int get isDeleted => _isDeleted;

  String get postDetail => _postDetail;

  String get postImage => _postImage;

  String get createdBy => _createdBy;

  String get createdAt => _createdAt;



  //setters
  set categoryId(int categoryId) {
    this._categoryId = categoryId;
  }

  set postId(int postId) {
    this._postId = postId;
  }
  set likes(int likes) {
    this._likes = likes;
  }
  set reports(int reports) {
    this._reports = reports;
  }
  set isDeleted(int isDeleted) {
    this._isDeleted = isDeleted;
  }

  set postDetail(String postDetail) {
    this._postDetail = postDetail;
  }

  set postImage(String postImage) {
    this._postImage = postImage;
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
    if (categoryId != null) {
      map['postId'] = _postId;
    }
    map['categoryId'] = _categoryId;
    map['likes'] = _likes;
    map['reports'] = _reports;
    map['isDeleted'] = _isDeleted;
    map['postDetail'] = _postDetail;
    map['postImage'] = _postImage;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;

    return map;
  }

  // Extract a Category object from a Map object
  Post.fromMapObject(Map<String, dynamic> map) {
    this._postId = map['postId'];
    this._categoryId = map['categoryId'];
    this._likes = map['likes'];
    this._reports = map['reports'];
    this._isDeleted = map['isDeleted'];
    this._postDetail = map['postDetail'];
    this._postImage = map['postImage'];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
  }


//  DatabaseHelper databaseHelper = DatabaseHelper();
//
//  static Database _database;
//  Future<Database> get database async {
//    return databaseHelper.database;
//  }






  ///////****************************Category Query Functions****************************************////////

  // Fetch Operation: Get all objects from database
//  Future<List<Map<String, dynamic>>> getCategoryMapList() async {
//    Database db = await databaseHelper.database;
////		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//    var result = await db.query(categoryTable, orderBy: '$colCategoryId ASC');
//    return result;
//  }
//
//  // Insert Operation: Insert object to database
//  Future<int> insertCategory(Category category) async {
//    Database db = await databaseHelper.database;
//    var result = await db.insert(categoryTable, category.toMap());
//    return result;
//  }
//
//  // Update Operation: Update a object and save it to database
//  Future<int> updateCategory(Category category) async {
//    var db = await databaseHelper.database;
//    var result = await db.update(categoryTable, category.toMap(),
//        where: '$colCategoryId = ?', whereArgs: [category.categoryId]);
//    return result;
//  }
//
//  // Delete Operation: Delete a object from database
//  Future<int> deleteCategory(int id) async {
//    var db = await databaseHelper.database;
//    int result = await db
//        .rawDelete('DELETE FROM $categoryTable WHERE $colCategoryId = $id');
//    return result;
//  }
//
//  // Get number of objects in database
//  Future<int> getCategoryCount() async {
//    Database db = await databaseHelper.database;
//    List<Map<String, dynamic>> x =
//    await db.rawQuery('SELECT COUNT (*) from $categoryTable');
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }
//
//  // Get the 'Map List' [ List<Map> ] and convert it to 'Obj List' [ List<Obj> ]
//  Future<List<Category>> getCategoryList() async {
//    var categoryMapList =
//    await getCategoryMapList(); // Get 'Map List' from database
//    int count =
//        categoryMapList.length; // Count the number of map entries in db table
//
//    List<Category> categoryList = List<Category>();
//    // For loop to create a 'Obj List' from a 'Map List'
//    for (int i = 0; i < count; i++) {
//      categoryList.add(Category.fromMapObject(categoryMapList[i]));
//    }
//
//    return categoryList;
//  }

///////////////////********************End**********************///////////////////////////
}
