import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';
//import 'DBHelper.dart';

class Comment {
//  Comment();
  Comment.empty();
  int _commentId;
  int _postId;
  String _comment;
  String _createdByUserId;
  String _createdBy;
  String _updatedBy;
  DateTime _updatedAt;
  DateTime _createdAt;

  static final Comment instance = Comment._privateConstructor();


//  String description;
  Comment(this._commentId, this._postId, this._comment, this._createdAt,
      this._createdBy, this._updatedAt, this._updatedBy);

  Comment.map(dynamic obj) {
    this._commentId = obj['commentId'];
    this._postId = obj['postId'];
    this._comment = obj['comment'];
    this._createdAt = obj['createdAt'];
    this._createdBy = obj['createdBy'];
    this._updatedAt = obj['updatedAt'];
    this._updatedBy = obj['updatedBy'];
  }

  int get commentId => _commentId;

  int get postId => _postId;

  String get comment => _comment;

  String get createdBy => _createdBy;

  String get updatedBy => _updatedBy;

  DateTime get createdAt => _createdAt;

  DateTime get updatedAt => _updatedAt;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['postId'] = _postId;
    map['comment'] = _comment;
    map['createdAt'] = _createdAt;
    map['createdBy'] = _createdBy;
    map['updatedAt'] = _updatedAt;
    map['updatedBy'] = _updatedBy;
    return map;
  }

  Comment.fromMap(Map<String, dynamic> map) {
    this._commentId = map['commentId'];
//    this._postId = map['postId'];
    this._comment = map['comment'];
    this._createdByUserId=map['createdByUserId'];
    this._createdAt = DateTime.parse(map['createdAt']);
    this._createdBy = map['createdBy'];
//    this._updatedAt = DateTime.parse(map['updatedAt']);
//    this._updatedBy = map['updatedBy'];
  }
//  static final _databaseName = APPLIC.databaseName;
//  static final _databaseVersion = APPLIC.databaseVersion;

  static final table = "comments";

  static final columnCommentId = "commentId";
  static final columnPostId = "postId";
  static final columnComment = "comment";
  static final columnCreatedBy = "createdBy";
  static final columnUpdatedBy = "updatedBy";
  static final columnCreatedAt = "createdAt";
  static final columnUpdatedAt = "updatedAt";

  // only have a single app-wide reference to the database
  Comment._privateConstructor();

//  static final Comment instance = Comment._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  DatabaseHelper databaseHelper = DatabaseHelper();
//  Future<Database> get database async {
//    return DBHelper.instance.database;
//  }

//  initDatabase() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, _databaseName);
//
//    return await openDatabase(path,
//        version: _databaseVersion, onCreate: _onCreate);
//  }

  Future _onCreate(Database db, int version) async {}

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await databaseHelper.database;
    int ab = await db.insert(table, row);
    print(ab);
    return ab;
  }

  Future<List> queryAllRows() async {
    Database db = await databaseHelper.database;
    var list = await db.rawQuery("SELECT * FROM $table");
//    print(list);
    return list.toList();
  }

  Future<Comment> getItem(int id) async {
    var dbClient = await databaseHelper.database;
    var result = await dbClient.rawQuery("SELECT * FROM $table WHERE id = $id");
    if (result.length == 0) return null;
    return new Comment.fromMap(result.first);
  }

  Future<int> queryRowCount() async {
    Database db = await databaseHelper.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

//  Future<int> update(Map<String, dynamic> row) async {
//    Database db = await instance.database;
//    int id = row[columnId];
//    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//  }
//
//  Future<int> delete(int id) async {
//    Database db = await instance.database;
//    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//  }
  @override
  String toString() {
//    return '${name} ${id}';
  }
}
