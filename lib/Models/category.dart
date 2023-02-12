import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class Category {
  int _categoryId;
  String _categoryName;
  String _createdBy;
  String _createdAt;

  //****************Catergory Table*********************//
  String categoryTable = 'category_table';
  String colCategoryId = 'categoryId';
  String colCategoryName = 'categoryName';
  String colCreatedBy = 'createdby';
  String colCreatedAt = 'createdAt';

  //**********************End******************************//

  Category.empty();

  Category(this._categoryName, this._createdBy, this._createdAt);

  Category.withId(this._categoryId, this._categoryName, [this._createdAt]);

  int get categoryId => _categoryId;

  String get categoryName => _categoryName;

  String get createdBy => _createdBy;

  String get createdAt => _createdAt;

  set categoryName(String categoryName) {
    this._categoryName = categoryName;
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
      map['categoryId'] = _categoryId;
    }
    map['categoryName'] = _categoryName;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;

    return map;
  }

  // Extract a Category object from a Map object
  Category.fromMapObject(Map<String, dynamic> map) {
    this._categoryId = map['categoryId'];
    this._categoryName = map['categoryName'];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
  }

  DatabaseHelper databaseHelper = DatabaseHelper();

  static Database _database;

  Future<Database> get database async {
    return databaseHelper.database;
  }

  ///////****************************Category Query Functions****************************************////////

  // Fetch Operation: Get all objects from database
  Future<List<Map<String, dynamic>>> getCategoryMapList() async {
    Database db = await databaseHelper.database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(categoryTable, orderBy: '$colCategoryId ASC');
    return result;
  }

  // Insert Operation: Insert object to database
  Future<int> insertCategory(Category category) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(categoryTable, category.toMap());
    return result;
  }

  // Update Operation: Update a object and save it to database
  Future<int> updateCategory(Category category) async {
    var db = await databaseHelper.database;
    var result = await db.update(categoryTable, category.toMap(),
        where: '$colCategoryId = ?', whereArgs: [category.categoryId]);
    return result;
  }

  // Delete Operation: Delete a object from database
  Future<int> deleteCategory(int id) async {
    var db = await databaseHelper.database;
    int result = await db
        .rawDelete('DELETE FROM $categoryTable WHERE $colCategoryId = $id');
    return result;
  }

  // Get number of objects in database
  Future<int> getCategoryCount() async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $categoryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Obj List' [ List<Obj> ]
  Future<List<Category>> getCategoryList() async {
    var categoryMapList = await getCategoryMapList(); // Get 'Map List' from database
    int count = categoryMapList.length; // Count the number of map entries in db table

    List<Category> categoryList = List<Category>();
    // For loop to create a 'Obj List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      categoryList.add(Category.fromMapObject(categoryMapList[i]));
    }

    return categoryList;
  }

  Future<Category> getSingleCategory(int id) async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> categoryMap = await db
        .rawQuery('SELECT * FROM $categoryTable WHERE $colCategoryId = $id');
    var singleCategory;
    if (categoryMap.isNotEmpty) {
      singleCategory = Category.fromMapObject(categoryMap[0]);
    }

    return singleCategory;
  }

  void removeDeletedRows(List<Category> list) async {
    List<Category> cached = await getCategoryList();
    List<int> notDeletedList = [];
    int notInFetchedMismatchCount;
    List<int> deletedList = [];
    cached.forEach((element) {
      notInFetchedMismatchCount = 0;
      for (int i = 0; i < list.length; i++) {
        if (element.categoryId == list[i].categoryId) {
          notDeletedList.add(element.categoryId);
        } else {
          ++notInFetchedMismatchCount;
          //if mismatch has reached to the number of items in the fetched one the item doesn't exist
          if ((notInFetchedMismatchCount) == list.length) {
            deletedList.add(element.categoryId);
          }
        }
      }
    });

    //delete query for the removed ones
    deletedList.forEach((id) {
      deleteCategory(id);
    });

  }
  Future<List<Category>> queryAllRows() async {
    List<Category> fetchedData = [];
    await dio.get(
      '/category',
    ).then((response) {
      print(response);
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data
            .length; i++) {
          var singleCategory = Category.fromMapObject(
              response.data[i]);
          fetchedData.add(singleCategory);
        }
      }
    });
    return fetchedData;
  }

///////////////////********************End**********************///////////////////////////
}
