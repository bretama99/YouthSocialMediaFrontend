import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'package:youth_and_adolesence/Models/health_institution.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class User extends ChangeNotifier {
  String _userId;
  String _firstName;
  String _fatherName;
  String _gender;
  DateTime _birthDate;
  String _email;
  String _password;
  String _mobilePhone;
  String _userType;
  String _userStatus;
  int _institutionId;
  String _address;
  DateTime _createdAt;
  String _createdBy;
  DateTime _updatedAt;
  String _updatedBy;
  String _institutionName;
  String _profilePicture;
  String _professionalyVerified;
  String _verifiedBy;
  DateTime _verifiedDate;
  int _totalPages;
//  Role _selectedRole;
//  Role get getSelectedRole => _selectedRole;
//  updatePageState(Role selectedObj){
//    _selectedRole=selectedObj;
//    notifyListeners();
//    //code to do
//  }
  User(this._userId,this._firstName,this._fatherName,this._gender,this._birthDate,this._email,this._password,this._mobilePhone,this._userType
  ,this._userStatus,this._institutionId,this._address,this._createdBy,this._updatedBy,this._profilePicture);

  User.map(dynamic obj){
    this._userId = obj['userId'];
    this._firstName = obj['firstName'];
    this._fatherName = obj['fatherName'];
    this._gender = obj['gender'];
    this._birthDate = obj['birthDate'];
    this._email = obj['email'];
    this._password = obj['password'];
    this._mobilePhone = obj['mobilePhone'];
    this._userType = obj['userType'];
    this._userStatus = obj['userStatus'];
    this._institutionId = obj['institutionId'];
    this._profilePicture=obj['profilePicture'];
    this._address = obj['address'];
    this._createdAt=obj['createdAt'];
    this._createdBy = obj['createdBy'];
    this._updatedAt= obj['updatedAt'];
    this._updatedBy = obj['updatedBy'];
    this._professionalyVerified=obj['professionalyVerified'];
  }

  User.empty();
  String get userId => _userId;
  String get firstName => _firstName;
  String  get fatherName => _fatherName;
  String  get gender => _gender;
  DateTime  get birthDate => _birthDate;
  String  get email => _email;
  String  get password => _password;
  String get mobilePhone =>_mobilePhone;
  String get profilePicture=>_profilePicture;
  String get userType=>_userType;
  String get userStatus => _userStatus;
  int get institutionId => _institutionId;
  String get address => _address;
  String get professionalyVerified=>_professionalyVerified;
  DateTime get createdAt => _createdAt;
  String get createdBy => _createdBy;
  DateTime get updatedAt => _updatedAt;
  String get updatedBy => _updatedBy;

  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map['firstName']=_firstName;
    map['professionalyVerified']=_professionalyVerified;
    map['fatherName']=_fatherName;
    map['gender']=_gender;
    map['birthDate']=_birthDate;
    map['email']=_email;
    map['password']=_password;
    map['mobilePhone']=_mobilePhone;
    map['userType']=_userType;
    map['profilePicture']=_profilePicture;
    map['userStatus']=_userStatus;
    map['institutionId']=_institutionId;
    map['address']=_address;
    map['createdAt']=_createdAt;
    map['createdBy']=_createdBy;
    map['updatedAt']=_updatedAt;
    map['updatedBy']=_updatedBy;
    return map;
  }
  User.fromMap(Map<String,dynamic>  map){
    this._userId= map['userId'];
    this._firstName = map['firstName'];
    this._fatherName = map['fatherName'];
    this._email = map['email'];
    this._gender = map['gender'];
    this._mobilePhone = map['mobilePhone'];
    this._userType = map['userType'];
    this._userStatus = map['userStatus'];
    this._institutionId = map['institutionId'];
    this._institutionName=map['institutionName'];
    this._profilePicture=map['profilePicture'];
//    this._birthDate = DateTime.parse(map['birthDate']);
    this._address = map['address'];
//    this._professionalyVerified=map['professionalyVerified'];
//    this._verifiedBy=map['verifiedBy'];
//    this._verifiedDate=DateTime.parse(map['verifiedDate']);
//    this._totalPages=map['totalPages'];
//    this._createdAt = DateTime.parse(map['createdAt']);
    this._createdBy=map['createdBy'];
//    this._updatedAt = DateTime.parse(map['updatedAt']);
    this._updatedBy=map['updatedBy'];
  }
  //to select healthInstitution when registering
  HealthInstitution _selectedHealthInstitution;
  HealthInstitution get getSelectedHealthInstitution => _selectedHealthInstitution;
  updatePageState(/*Role selectedObj*/{HealthInstitution selectedHealthInstitution}){
    if(selectedHealthInstitution!=null)
      _selectedHealthInstitution=selectedHealthInstitution;
    notifyListeners();
    //code to do
  }

//  static final _databaseName = APPLIC.databaseName;
//  static final _databaseVersion = APPLIC.databaseVersion;

  static final table = 'users';

  static final columnId = 'userId';
  static final columnFirstName = 'firstName';
  static final columnLastName = 'fatherName';
  static final columnGender = 'gender';
  static final columnBirthDate = 'birthDate';
  static final columnEmail = 'email';
  static final columnProfilePicture = "profilePicture";
  static final columnPassword = 'password';
  static final columnPhoneNumber = 'mobilePhone';
  static final columnUserType = 'userType';
  static final columnUserStatus = 'userStatus';
  static final columnInstitutionId = 'institutionId';
  static final columnAddress = 'address';

//  static final columnCreatedAt = 'createdAt';
  static final columnCreatedBy = 'createdBy';
//  static final columnUpdatedAt = 'updatedAt';
  static final columnUpdatedBy = 'updatedBy';
  // make this a singleton class
  DatabaseHelper databaseHelper = DatabaseHelper();
  User._privateConstructor();
  static final User instance = User._privateConstructor();

  // only have a single app-wide reference to the database
//  static Database _database;
//  Future<Database> get database async {
//    return DBHelper.instance.database;
/*
    if (_database != null) return _database;

    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;*/
//  }
//  _initDatabase() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, _databaseName);
//
//    return await openDatabase(path,
//        version: _databaseVersion,
//        onCreate: _onCreate);
//  }

  Future _onCreate(Database db, int version) async {

      }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await databaseHelper.database;
    return await db.insert(table, row);
  }

  Future<List<User>> queryAllRows() async {
    List<User> fetchedData = [];
//    Database db = await instance.database;
   await dio.get('/account',
    ).then((response) {
      if (response.statusCode == 200) {
        for (int i = 0; i <response.data.length; i++) {
          print(response.data[i]);

          var singleCategory = User.fromMap(
              response.data[i]);
          fetchedData.add(singleCategory);
        }
      }
    });
    return fetchedData;
  }
}
