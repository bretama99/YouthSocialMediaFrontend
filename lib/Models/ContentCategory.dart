import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class ContentCategory {
//
//  static final _databaseName = APPLIC.databaseName;
//  static final _databaseVersion = APPLIC.databaseVersion;

  static final table = 'post_categories';

  static final columnId = 'categoryId';
  static final columnName = 'categoryName';
  static final columnCreatedAt = 'createdAt';
  static final columnCreatedBy = 'createdBy';
  static final columnUpdatedAt = 'updatedAt';
  static final columnUpdatedBy = 'updatedBy';
  DatabaseHelper databaseHelper = DatabaseHelper();

  // make this a singleton class
  ContentCategory._privateConstructor();
  static final ContentCategory instance = ContentCategory._privateConstructor();
  ContentCategory.empty();
  int _categoryId;
  String _categoryName;
  DateTime _createdAt;
  String _createdBy;
  DateTime _updatedAt;
  String _updatedBy;


  ContentCategory(this._categoryId, this._categoryName,this._createdAt,this._createdBy,this._updatedAt,this._updatedBy);

  ContentCategory.map(dynamic obj){
    this._categoryId = obj['categoryId'];
    this._categoryName = obj['categoryName'];
    this._createdAt=obj['createdAt'];
    this._createdBy = obj['createdBy'];
    this._updatedAt= obj['updatedAt'];
    this._updatedBy = obj['updatedBy'];
  }
  int get categoryId => _categoryId;
  String get categoryName => _categoryName;
  DateTime get createdAt=>_createdAt;
  String get createdBy =>_createdBy;
  DateTime get updatedAt => _updatedAt;
  String get updatedBy => _updatedBy;
  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map['categoryName']=_categoryName;
    map['createdAt']=_createdAt;
    map['createdBy']=_createdBy;
    map['updatedAt']=_updatedAt;
    map['updatedBy']=_updatedBy;
    return map;
  }
  ContentCategory.fromMap(Map<String,dynamic>  map){
    this._categoryId=map['categoryId'];
    this._categoryName=map['categoryName'];
    this._createdAt=map['createdAt'];
    this._createdBy=map['createdBy'];
    this._updatedAt=map['updatedAt'];
    this._updatedBy=map['updatedBy'];
  }
  // only have a single app-wide reference to the database
//  static Database _database;
//  Future<Database> get database async {
//    return DBHelper.instance.database;
    /*if (_database != null) return _database;

    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;*/
//  }

//  _initDatabase() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    print("documentsDirectory.path: "+documentsDirectory.path);
//    String path = join(documentsDirectory.path, _databaseName);
//
//    return await openDatabase(path,
//        version: _databaseVersion,
//        onCreate: _onCreate);
//  }
//
//
//  Future _onCreate(Database db, int version) async {
//  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await databaseHelper.database;
    return await db.insert(table, row);
  }

  Future<List<ContentCategory>> queryAllRows() async {
    List<ContentCategory> fetchedData = [];
    await dio.get(
      '/category',
    ).then((response) {
      print(response);
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data
            .length; i++) {
          var singleCategory = ContentCategory.fromMap(
              response.data[i]);
          fetchedData.add(singleCategory);
        }
      }
    });
    return fetchedData;
  }
    Future<int> queryRowCount() async {
      Database db = await databaseHelper.database;
      return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $table'));
    }

    Future<int> update(Map<String, dynamic> row) async {
      Database db = await databaseHelper.database;
      int id = row[columnId];
      return await db.update(
          table, row, where: '$columnId = ?', whereArgs: [id]);
    }

    Future<ContentCategory> find(int id) async {
      Database db = await databaseHelper.database;
      List<Map<String, dynamic>> queryResult = await db.query(
          table, where: '$columnId = ?', whereArgs: [id]);
      ContentCategory contentCategory;
      for (int i = 0; i < queryResult.length; i++) {
        Map<String, dynamic> obj = queryResult[i];
        contentCategory = new ContentCategory(obj[columnId], obj[columnName],
            obj[columnCreatedAt], obj[columnCreatedBy], obj[columnUpdatedAt],
            obj[columnUpdatedBy]);
      }
      return contentCategory;
    }

    Future<int> delete(int id) async {
      Database db = await databaseHelper.database;
      return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    }

  ContentCategory empty() {}
//  @override
//  String toString() {
//    return '${name} ${id}';
//  }

  }