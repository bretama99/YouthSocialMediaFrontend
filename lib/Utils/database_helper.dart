import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Models/faq.dart';
import 'package:youth_and_adolesence/Models/health_institution.dart';
import 'package:youth_and_adolesence/Models/possible_answers.dart';
import 'package:youth_and_adolesence/Models/question.dart';
import 'package:youth_and_adolesence/Models/Post.dart';
import 'package:youth_and_adolesence/Models/Comment.dart';
import 'package:youth_and_adolesence/Models/user_assistance_request.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database
  static Category category = new Category.empty();
  static Question question = new Question.empty();
  static PossibleAnswer possibleAnswer = new PossibleAnswer.empty();
  static UserAssistanceRequest assistanceRequest =
      new UserAssistanceRequest.empty();
  static FAQ faq = new FAQ.empty();
  static HealthInstitution healthInstitution = new HealthInstitution.empty();

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + AppConfig.databaseName;

    // Open/create the database at a given path
    var youthAppDatabase = await openDatabase(path,
        version: AppConfig.databaseVersion, onCreate: _createDb);
    return youthAppDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE ${category.categoryTable} (${category.colCategoryId} INTEGER PRIMARY KEY, ${category.colCategoryName} TEXT, ${category.colCreatedBy} TEXT, ${category.colCreatedAt} TEXT)');
    await db.execute(
        """CREATE TABLE ${question.questionTable} (${question.colQuestionId} INTEGER PRIMARY KEY, ${category.colCategoryId} INTEGER, ${question.colQuestion} TEXT, ${question.colLevel} TEXT,${question.colCreatedBy} TEXT, ${question.colCreatedAt} TEXT, FOREIGN KEY (${category.colCategoryId}) REFERENCES ${category.categoryTable} (${category.colCategoryId}) ON DELETE NO ACTION ON UPDATE NO ACTION)""");
    await db.execute(
        """CREATE TABLE ${possibleAnswer.optionTable} (${possibleAnswer.colOptionId} INTEGER PRIMARY KEY, ${question.colQuestionId} INTEGER, ${possibleAnswer.colLabel} TEXT, ${possibleAnswer.colLabelValue} TEXT, ${possibleAnswer.colIsAnswer} INTEGER, ${possibleAnswer.colCreatedBy} TEXT, ${possibleAnswer.colCreatedAt} TEXT, FOREIGN KEY (${question.colQuestionId}) REFERENCES ${question.questionTable} (${question.colQuestionId}) ON DELETE NO ACTION ON UPDATE NO ACTION)""");
    await db.execute(
        """CREATE TABLE ${assistanceRequest.requestTable} (${assistanceRequest.colRequestId} INTEGER PRIMARY KEY,${assistanceRequest.colCategory} TEXT, ${assistanceRequest.colRequestDetail} TEXT, ${assistanceRequest.colLatitude} TEXT, ${assistanceRequest.colLongitude} TEXT, ${assistanceRequest.colStatus} TEXT, ${assistanceRequest.colCreatedAt} TEXT)""");
    await db.execute(
        """CREATE TABLE ${faq.faqTable} (${faq.colFaqId} INTEGER PRIMARY KEY, ${faq.colTitle} TEXT, ${faq.colAnswer} TEXT, ${assistanceRequest.colCreatedBy} TEXT, ${assistanceRequest.colCreatedAt} TEXT)""");
    await db.execute(
        """CREATE TABLE ${healthInstitution.institutionTable} (${healthInstitution.colInstitutionId} INTEGER PRIMARY KEY, ${healthInstitution.colInstitutionName} TEXT, ${healthInstitution.colCategory} TEXT, ${healthInstitution.colAddress} TEXT, ${assistanceRequest.colLatitude} TEXT, ${assistanceRequest.colLongitude} TEXT, ${assistanceRequest.colCreatedBy} TEXT, ${assistanceRequest.colCreatedAt} TEXT)""");

    await db.execute('''
          CREATE TABLE IF NOT EXISTS ''' +
        Post.table +
        ''' (
            ''' +
        Post.columnPostId +
        ''' INTEGER PRIMARY KEY,
            ''' +
        Post.columnCategoryId +
        ''' INTEGER,
            ''' +
        Post.columnPostDetail +
        ''' TEXT,
            ''' +
        Post.columnPostFile +
        ''' TEXT,
            ''' +
        Post.columnCreatedBy +
        ''' INTEGER,
            ''' +
        Post.columnUpdatedBy +
        ''' INTEGER
            ''' +
        Post.columnCreatedAt +
        ''' TIMESTAMP,
            ''' +
        Post.columnUpdatedAt +
        ''' TIMESTAMP
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS ''' +
        Comment.table +
        ''' (
            ''' +
        Comment.columnCommentId +
        ''' INTEGER PRIMARY KEY,
            ''' +
        Comment.columnPostId +
        ''' INTEGER ,
            ''' +
        Comment.columnComment +
        ''' TEXT NOT NULL,
            ''' +
        Comment.columnCreatedBy +
        ''' INTEGER,
            ''' +
        Comment.columnUpdatedBy +
        ''' INTEGER,
            ''' +
        Comment.columnCreatedAt +
        ''' TIMESTAMP,
            ''' +
        Comment.columnUpdatedAt +
        ''' TIMESTAMP
            
          )
          ''');
  }
}
