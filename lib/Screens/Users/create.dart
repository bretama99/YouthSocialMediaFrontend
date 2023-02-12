import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

import 'package:youth_and_adolesence/Models/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Models/health_institution.dart';
import 'package:youth_and_adolesence/Screens/Users/index.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';
import 'package:youth_and_adolesence/Utils/widget.dart';
class UsersCreate extends StatefulWidget {
  @override
  _UsersCreateState createState() => _UsersCreateState();
}

class _UsersCreateState extends State<UsersCreate> {
//  Dio dio = new Dio();
  List<String> _list = ['Super admin','Admin','Health professional','User'];
  var professionalCategory =["Gynaecologist","Psychiatrist","Psycologist"];
  List<String> healtItems = [];
  List<HealthInstitution> _health = [];
  final _formKey = GlobalKey<FormState>();
  var user = User.instance;
//  final role = Role.instance;
  final healthInstitute = HealthInstitution.empty();
  String selectedGender = "";
  String selectedInstituteId;
  DateTime _dateTime;
  int selectedHealthInstitution;
  String selectedRole = '';
  String selectedCategory = 'Psycologist';
  RegExp alphabetsOnly = RegExp(r'^[a-zA-Z]+$');
  RegExp patternEmail = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  int healthInstitutionIds;
  final FirstNameTfController = TextEditingController();
  final LastNameTfController = TextEditingController();
  final MiddleNameTfController = TextEditingController();
  final UsernameIfController = TextEditingController();
  final BirthDateTfController = TextEditingController();
  final GenderTfController = TextEditingController();
  final AdressIfController = TextEditingController();
  final PhoneNumberTfController = TextEditingController();
  final EmailTfController = TextEditingController();
  final PasswordTfController = TextEditingController();
  final ConfirmPasswordTfController = TextEditingController();
  final RoleIdTfController = TextEditingController();
  final IsVerifiedTfController = TextEditingController();
  final VerifiedDateTfController = TextEditingController();
  final VerifiedByTfController = TextEditingController();
  final StatusTfController = TextEditingController();
  final ResetCodeTfController = TextEditingController();
  final HealthInstitutionIdTfController = TextEditingController();
  final SupportingDocumentPathTfController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  DateTime _date = DateTime.now();
  var datePickerF = FocusNode();
  var firstNameF = FocusNode();
  var fatherNameF = FocusNode();
  var gFatherNameF = FocusNode();
  var userNameF = FocusNode();
  var emailF = FocusNode();
  var passwordF = FocusNode();
  var addressF = FocusNode();
  var confirmPasswordF = FocusNode();
  var mobilePhoneF = FocusNode();
  String userType = '';
  String fullName = '';
  String userId = '';
  HealthInstitution healthInstitution = new HealthInstitution.empty();
  List<HealthInstitution> healthInstitutionList = new List<HealthInstitution>();
//  onShowPicker: (context, currentValue) {
//  showDatePicker(
//  context: context,
//  firstDate: DateTime(1900),
//  initialDate: currentValue ?? DateTime.now(),
//  lastDate: DateTime(2100)).then((value) {
//  setState(() {
//  _dateTime = value;
//  });
//  });
//  },

  //image upload
  File _image;
  Future _getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image=image;
    });
  }
  final format = DateFormat("yyyy/MM/dd");
  Future<Null> _selectDate(BuildContext context)async {

    DateTime _datePicker = await showDatePicker(
      context: context,
//      initialDate:_date,
//      firstDate: DateTime(1900),
//      lastDate:DateTime(2020),
//      textDirection: TextDirection.LTR,
      initialDatePickerMode:DatePickerMode.day,
//      selectableDayPredicate: (DateTime val)=>val.weekday==6||val.weekday==7 ?false:true,
      builder:(BuildContext context, Widget child){
        return Theme(
          data:ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Color(0xFFC41A3B),
            accentColor: Color(0xFFC41A3B),

          ),
          child: child,
        );
      }
    );
    if(_datePicker!=null && _datePicker!=_date){
      setState(() {
        _date=_datePicker;
        print(_date.toString());
      });
    }
  }
  @override
  void initState() {
    BirthDateTfController.text=_dateTime.toString();
    _saveUser();
    getHealthInstitution();
    super.initState();
//    _query();
  }
  @override
  void dispose() {
    FirstNameTfController.dispose();
    LastNameTfController.dispose();
//    gFatherNameC.dispose();
    UsernameIfController.dispose();
    EmailTfController.dispose();
    PasswordTfController.dispose();
    ConfirmPasswordTfController.dispose();
    PhoneNumberTfController.dispose();
    BirthDateTfController.dispose();
    firstNameF.dispose();
    fatherNameF.dispose();
    gFatherNameF.dispose();
    userNameF.dispose();
    emailF.dispose();
    passwordF.dispose();
    confirmPasswordF.dispose();
    passwordF.dispose();
    mobilePhoneF.dispose();
    addressF.dispose();


    super.dispose();
  }
  String selectedInstituteName;

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("createUser").tr(),
            ),
              body: Container(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text("createUserAccount",
                            style: TextStyle(
                              color: AppTheme.titleTextColor,
                              fontSize: AppTheme.titleTextSize,
                            ),
                          ).tr(),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, firstNameF, fatherNameF);
                              },
                              controller: FirstNameTfController,
                              focusNode: firstNameF,
                              validator: (term) {
                                if (term.isEmpty) {
                                  return "enterFirstname".tr();
                                } else if (!alphabetsOnly.hasMatch(term)) {
                                  return "enterValidName".tr();
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "firstName".tr(),
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, fatherNameF, gFatherNameF);
                              },
                              controller: LastNameTfController,
                              focusNode: fatherNameF,
                              validator: (term) {
                                if (term.isEmpty) {
                                  return "enterFathername".tr();
                                } else if (!alphabetsOnly.hasMatch(term)) {
                                  return "enterValidName".tr();
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "fatherName".tr(),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              style: TextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),

                        ],
                    ),
                  ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 50.0,
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    readOnly: true,
                                    enableInteractiveSelection: false,
                                    initialValue: "+251",
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(), enabled: false),
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(
                                        context, mobilePhoneF, datePickerF);
                                  },
                                  focusNode: mobilePhoneF,
                                  controller: PhoneNumberTfController,
                                  maxLength: 9,
                                  validator: (term) {
                                    String patttern = r'(^[9][0-9]{8}$)';
                                    RegExp regExp = new RegExp(patttern);
                                    if (term.length == 0) {
                                      return 'pleaseEnterMobileNumber'.tr();
                                    } else if (!regExp.hasMatch(term)) {
                                      return 'pleaseEnterValidMobileNumber'.tr();
                                    } else if (term.length > 9 || term.length < 9) {
                                      return 'pleaseEnter9DigitsOnly'.tr();
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        FontAwesomeIcons.phone,
                                        color: Theme.of(context).primaryColor,
                                        size: 20.0,
                                      ),
                                      isDense: true,
                                      labelText: 'mobilePhone'.tr(),
                                      labelStyle: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context).primaryColor))),
                                ),
                                flex: 4,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: new EdgeInsets.all(8.0),
                            ),
                            new Text("Gender",
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppTheme.radioButtonTextSize,
                              ),
                            ).tr(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(
                                  value: "Female",
                                  groupValue: selectedGender,
                                  onChanged: (String value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                    print("prev gender: ${selectedGender}");
                                  },
                                ),
                                new Text("Female",
                                  style: new TextStyle(
                                    fontSize: AppTheme.radioButtonTextSize,
                                  ),
                                ).tr(),
                                new Radio(
                                  value: "Male",
                                  groupValue: selectedGender,
//                                      userObj.getSelectedGender,
                                  onChanged: (String value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                                new Text("Male",
                                  style: new TextStyle(
                                      fontSize: AppTheme.radioButtonTextSize),
                                ).tr(),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(children: <Widget>[
                            Container(
                              child: DateTimeField(
                                validator: (date) => date == null
                                    ? 'insertBirthOfDate'.tr()
                                    : null,
                                style: TextStyle(fontSize: 13.0),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: ('dateOfBirth').tr(),
                                  hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  labelStyle: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: Icon(
                                    FontAwesomeIcons.calendar,
                                    color: Theme.of(context).primaryColor,
                                    size: 20.0,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                controller: BirthDateTfController,
                                focusNode: datePickerF,
                                onFieldSubmitted: (term) {
                                  datePickerF.unfocus();
                                },
                                resetIcon: Icon(
                                  FontAwesomeIcons.redo,
                                  size: 10.0,
                                ),
                                format: format,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: DateTime(1970),
                                      lastDate: DateTime.now());
                                },
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
//                            onFieldSubmitted: (term) {
//                              _fieldFocusChange(
//                                  context, addressC, gFatherNameF);
//                            },

                            controller: AdressIfController,
                            focusNode: addressF,
                            validator: (term) {
                              if (term.isEmpty) {
                                return "enterYourAddress".tr();
                              } else if (!alphabetsOnly.hasMatch(term)) {
                                return "enterValidAddress".tr();
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                FontAwesomeIcons.voicemail,
                                color: Theme.of(context).primaryColor,
                                size: 20.0,
                              ),
                              labelText: "address".tr(),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            style: TextStyle(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, emailF, passwordF);
                            },
                            controller: EmailTfController,
                            focusNode: emailF,
                            validator: (term) {
                              if (term.isEmpty) {
                                return "enterYourEmail".tr();
                              }
                              else if (!patternEmail.hasMatch(term)) {
                                return "enterValidEmail".tr();
                              }
                              else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                isDense: true,
                                suffixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                  size: 20.0,
                                ),
                                labelText: 'Email'.tr(),
                                labelStyle: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                // hintText: 'EMAIL',
                                // hintStyle: ,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                        Theme.of(context).primaryColor))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:8),
                          child: Row(
                            children: [
//                              Flexible(
//                                child: Center(
//                                  child: Text("userType").tr(),
//                                ),
//                              ),
                              Flexible(
                                child: DropdownButtonFormField(hint: Text("Select user type"),
                                  validator: (term) => term == null
                                      ? "Select User type"
                                      : null,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.user,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _list.map((String obj) {
                                    return DropdownMenuItem<String>(
                                      value: obj,
                                      child: Text(obj),
                                    );
                                  }).toList(),
                                  onChanged: (String val) {
                                    setState(() {
                                      selectedRole = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
//                              Flexible(
//                                child: Center(
//                                  child: Text("Category"),
//                                ),
//                              ),
                              Flexible(
                                child: DropdownButtonFormField(hint: Text("Select Category"),
                                  validator: (term) => term == null
                                      ? "Select Category"
                                      : null,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.userCircle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: professionalCategory
                                      .map((value) => DropdownMenuItem(
                                    child: Text(value),
                                    value:
                                    value.toString(),
                                  ))
                                      .toList(),
//                                  value: selectedCategory,
                                  onChanged: (String val) {
                                    setState(() {
                                      selectedCategory = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8),
                          child: Expanded(
                            child: Row(
                              children: [
//                                Expanded(
//                                  flex: 2,
//                                  child: Center(child: Text("healthInstitution").tr(),),
//                                ),
//                                Spacer(),
                                    Expanded(
                                        flex: 4,
                                        child: DropdownButtonFormField(hint: Text("Select Instittution"),
                                            validator: (term) => term == null
                                                ? "Select Instittution"
                                                : null,
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                FontAwesomeIcons.home,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                          items: healthInstitutionList.map((obj) {
                                            return DropdownMenuItem(
                                              value:obj.institutionId,
                                              child: Text(obj.institutionName),
                                            );
                                          }).toList(),
//                                        value: userObj.getSelectedHealthInstitution,
                                          onChanged: (val) {
                                            setState(() {
                                              selectedHealthInstitution = val;
                                              print(selectedHealthInstitution);
                                            });
                                          },
                                          value:selectedHealthInstitution
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, passwordF, confirmPasswordF);
                            },
                            controller: PasswordTfController,
                            focusNode: passwordF,
                            validator: (term) {
                              if (term.isEmpty) {
                                return "enterYourPassword".tr();
                              } else if (term.length < 6) {
                                return "minimumPasswordLengthIs6".tr();
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Password'.tr(),
                              isDense: true,
                              labelStyle: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              suffixIcon: Icon(
                                Icons.security,
                                color: Theme.of(context).primaryColor,
                                size: 20.0,
                              ),
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          child: TextFormField(
                            onFieldSubmitted: (term) {
                              confirmPasswordF.unfocus();
                            },
                            controller: ConfirmPasswordTfController,
                            focusNode: confirmPasswordF,
                            validator: (term) {
                              if (term.isEmpty) {
                                return "enterYourConfirmationPassword".tr();
                              } else if (term != PasswordTfController.text) {
                                return "yourPasswordsDon'tMatch!".tr();
                              } else if (term.length < 6) {
                                return "minimumPasswordLengthIs6".tr();
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                isDense: true,
                                suffixIcon: Icon(
                                  FontAwesomeIcons.userSecret,
                                  color: Theme.of(context).primaryColor,
                                  size: 20.0,
                                ),
                                labelText: 'confirmPassword'.tr(),
                                labelStyle: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                        Theme.of(context).primaryColor))),
                          ),
                        ),



                        SizedBox(height: 20,),

                        Divider(height: AppTheme.deviderHeight,),
                        RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) return;
                            _insert();
//                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => MyHomePage(), fullscreenDialog: true, maintainState: true));
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: AppTheme.buttonTextColor,
                              fontSize: AppTheme.buttonTextSize,
                            ),
                          ),
                          color: AppTheme.buttonColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

          );

  }
//  healthInstitutionList
//  Future<List<HealthInstitution>> _query() async {
//    print("+++++++++++++++++++++++++");
//    final allRows = await healthInstitute.queryAllRows();
//    allRows.forEach((row) => print(row));
//    return allRows;
//  }
  void getHealthInstitution() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) async {

      Future<List<HealthInstitution>> healthInstitutionListFuture = healthInstitution.getInstitutionList();
      healthInstitutionListFuture.then((healthInstitutionList) {
        setState(() {
          this.healthInstitutionList = healthInstitutionList;
        });
      });
    });
  }
//  postData(Map<String, dynamic> body)async{
//    var dio = Dio();
//    try {
//      FormData formData = new FormData.fromMap(body);
//      var response = await dio.post(url, data: formData);
//      return response.data;
//    } catch (e) {
//      print(e);
//    }
//  }
_saveUser() async{
  var userInfo = await SharedPreferences.getInstance();
  userType = userInfo.get("userType");
  fullName = userInfo.get("fullName");
  userId = userInfo.get("userId");
}

  void _insert() async {
    FormData formData = new FormData.fromMap({
      "firstName": FirstNameTfController.text,
      "fatherName": LastNameTfController.text,
      "gender": selectedGender,
      "birthDate": BirthDateTfController.text,
      "email": EmailTfController.text,
      "password": PasswordTfController.text,
      "mobilePhone": PhoneNumberTfController.text,
      "userType": selectedRole,
      "userStatus": "Active",
      "institutionId": healthInstitutionIds,
      "createdBy": userId,
      "address": AdressIfController.text,
    });
    var response= await dio.post("/auth/signup", data: formData);
    if (response.statusCode == 200) {
      Toast.show("userCreatedSuccessfully".tr(), context, duration: 3);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => UsersIndex()));
    }
//    dio.post("/auth/signup",
//        data: {
//      "firstName": "brhane",
//      "fatherName": "tamrat",
//      "gender": "Male",
//      "birthDate": "2000-9-9",
//      "email": "brhanee@gmail.com",
//      "password": "123456",
//      "mobilePhone": "0930343434",
//      "userType": "Admin",
//      "userStatus": "Active",
//      "institutionId": 1,
//      "createdBy": "UsernameIfController.text",
//      "address": "AdressIfController.text"
//    }).then((response) => print(response));
//  }
  }
}
_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}