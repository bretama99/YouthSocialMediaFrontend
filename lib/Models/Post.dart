import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Models/Comment.dart';
//import 'package:youth_and_adolesence/Models/ContentCategory.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class Post extends ChangeNotifier{
//  static final _databaseName = APPLIC.databaseName;
//  static final _databaseVersion = APPLIC.databaseVersion;
  static final table = 'posts';
  static final columnPostId = 'postId';
  static final columnCategoryId = 'categoryId';
  static final columnPostDetail = 'postDetail';
  static final columnPostFile = 'postFile';
  static final columnCreatedAt = 'createdAt';
  static final columnCreatedBy = 'createdBy';
  static final columnUpdatedAt = 'updatedAt';
  static final columnUpdatedBy = 'updatedBy';

  // make this a singleton class
  Post._privateConstructor();

  static final Post instance = Post._privateConstructor();

  Post.empty();

  int _postId;
  int _categoryId;
  String _postDetail;
  String _postFile;
  List<Comment> _comments = [];
  String _categoryName;
  String _profession;
  String _institutionName;
  DateTime _createdAt;
  String _createdBy;
  DateTime _updatedAt;
  String _updatedBy;
  String _createdByUserId;
  int _likes;
  int _reports;
  int _totalPages;

  Post(
      this._postId,
      this._categoryId,
      this._postDetail,
      this._postFile,
      this._comments,
      this._createdByUserId,
      this._reports,
      this._likes,
      this._profession,
      this._institutionName,
      this._createdAt,
      this._createdBy,
      this._updatedAt,
      this._updatedBy);

  Post.map(dynamic obj) {
    this._postId = obj['postId'];
    this._categoryId = obj['categoryId'];
    this._postDetail = obj['postDetail'];
    this._postFile = obj['postFile'];
    this._comments = obj['comments'];
    this._createdAt = obj['createdAt'];
    this._createdBy = obj['createdBy'];
    this._updatedAt = obj['updatedAt'];
    this._updatedBy = obj['updatedBy'];
  }

  int get postId => _postId;

  int get categoryId => _categoryId;

  String get postDetail => _postDetail;

  String get postFile => _postFile;

  List<Comment> get comments => _comments;
  int get likes => _likes;
  int get reports =>_reports;
  String get profession =>_profession;
  String get institutionName=>_institutionName;
  DateTime get createdAt => _createdAt;
  String get createdByUserId =>_createdByUserId;
  String get createdBy => _createdBy;

  DateTime get updatedAt => _updatedAt;

  String get updatedBy => _updatedBy;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['categoryId'] = _categoryId;
    map['postDetail'] = _postDetail;
    map['postFile'] = _postFile;
    map['createdByUserId'] = _createdByUserId;
    map['comments'] = _comments;
    map['likes']=_likes;
    map['reports']=_reports;
    map['createdAt'] = _createdAt;
    map['createdBy'] = _createdBy;
    map['updatedAt'] = _updatedAt;
    map['updatedBy'] = _updatedBy;
    return map;
  }
   Post.fromMap(Map<String, dynamic> map){
    this._postId = map['postId'];
    this._categoryName = map['categoryName'];
    this._postDetail = map['postDetail'];
    this._postFile = map['postFileName'];

    this._comments = List<Comment>.from(map['comments'].map((x)=> Comment.fromMap(x)));
     this._likes=map['likes'];
     this._reports=map['reports'];
     this._profession=map['profession'];
     this._institutionName=map['institutionName'];
    this._createdAt = DateTime.parse(map['createdAt']);
    this._createdBy = map['createdBy'];
    this._createdByUserId = map['createdByUserId'];
    this._likes = map['likes'];
    this._reports = map['reports'];
//    this._createdBy = map['createdBy'];
    this._updatedAt = map['updatedAt'];
    this._updatedBy = map['updatedBy'];
  }
  DatabaseHelper databaseHelper = DatabaseHelper();
//to select the category when Posting
//  ContentCategory _selectedContentCategory;
//  ContentCategory get getSelectedContentCategory => _selectedContentCategory;
//  updatePageState({ContentCategory selectedContentCategory}){
//    if(selectedContentCategory!=null)
//      _selectedContentCategory=selectedContentCategory;
//    notifyListeners();
//  }

  // only have a single app-wide reference to the database
//  static Database _database;
//
//  Future<Database> get database async {
//    return DBHelper.instance.database;
//    /*if (_database != null) return _database;
//
//    // lazily instantiate the db the first time it is accessed
//    _database = await _initDatabase();
//    return _database;*/
//  }

//  _initDatabase() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    print("documentsDirectory.path: " + documentsDirectory.path);
//    String path = join(documentsDirectory.path, _databaseName);
//
//    return await openDatabase(path,
//        version: _databaseVersion, onCreate: _onCreate);
//  }

  Future _onCreate(Database db, int version) async {}

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await databaseHelper.database;
    return await db.insert(table, row);
  }

  Future<List<Post>> queryAllRows() async {
    List<Post> fetchedData = [];
    int j = 0;
    await dio.get('/post').then((response) {
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singlePost = Post.fromMap(response.data[i]);
          fetchedData.add(singlePost);
        }
      }
    });
    print(fetchedData);
    return fetchedData;
  }

  Future<int> queryRowCount() async {
    Database db = await databaseHelper.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await databaseHelper.database;
//    int id = row[columnId];
//    return await db.update(
//        table, row, where: '$columnId = ?', whereArgs: [id]);
  }

//  Future<Post> find(int id) async {
//    Database db = await instance.database;
//    List<Map<String, dynamic>> queryResult =
//        await db.query(table, where: '$columnPostId = ?', whereArgs: [id]);
//    Post contentCategory;
//    for (int i = 0; i < queryResult.length; i++) {
//      Map<String, dynamic> obj = queryResult[i];
//      contentCategory = new Post(
//          obj[columnPostId],
//          obj[columnCategoryId],
//          obj[comments],
//
//          obj[columnPostDetail],
//          obj[columnPostFile],
//          obj[columnCreatedAt],
//          obj[columnCreatedBy],
//          obj[columnUpdatedAt],
//          obj[columnUpdatedBy]);
////    }
//    return contentCategory;
//  }

  Future<int> delete(int id) async {
    Database db = await databaseHelper.database;
    return await db.delete(table, where: '$columnPostId = ?', whereArgs: [id]);
  }

  List<Comment> parseCommentsFromMap(List<dynamic> map) {
    print('In method');

    List<Comment> list = [];
    for (int i = 0; i < map.length; i++) {
      list.add(Comment.fromMap(map[i]));
      print(map[i]['comment']);
    }

    return list;
  }
}
