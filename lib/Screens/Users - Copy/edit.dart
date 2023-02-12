import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/User.dart';
import 'package:youth_and_adolesence/Models/User.dart';
import 'package:youth_and_adolesence/Models/health_institution.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';
import 'package:youth_and_adolesence/Utils/widget.dart';

class UserEdit extends StatefulWidget{
  User user;
  UserEdit(this.user);
  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  List<String> _list = ['Super admin','Admin','Health professional','User'];
  List<String> healtItems = [];
  List<HealthInstitution> _health = [];
//  final format = DateFormat("yyyy/MM/dd");
  final _formKey = GlobalKey<FormState>();
  var user = User.instance;
//  final role = Role.instance;
  final healthInstitute = HealthInstitution.empty();
  String selectedGender = "Female";
  String selectedInstituteId;
  DateTime _dateTime;
  int selectedHealthInstitution;
  String selectedRole = 'Admin';
  RegExp alphabetsOnly = RegExp(r'^[a-zA-Z]+$');
  RegExp patternEmail = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  int healthInstitutionIds;
  final FirstNameTfController = TextEditingController();
  // ignore: non_constant_identifier_names
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
  HealthInstitution healthInstitution = new HealthInstitution.empty();
  List<HealthInstitution> healthInstitutionList = new List<HealthInstitution>();
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
//  HealthInstitution healthInstitution = new HealthInstitution.empty();
//  List<HealthInstitution> healthInstitutionList = new List<HealthInstitution>();

  @override
  void initState() {
    getHealthInstitution();
    FirstNameTfController.text =widget.user.firstName;
    LastNameTfController.text =widget.user.fatherName;
    EmailTfController.text =widget.user.email;
    BirthDateTfController.text =widget.user.birthDate.toString();
    GenderTfController.text =widget.user.gender;
    AdressIfController.text =widget.user.address;
    PhoneNumberTfController.text =widget.user.mobilePhone;
    RoleIdTfController.text =widget.user.userType;
    HealthInstitutionIdTfController.text =widget.user.email;
//    _query();
    getHealthInstitution();
    updateUser();
    super.initState();
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
  final format = DateFormat("yyyy-MM-dd");
  updateUser() {
 dio.put('/accounts/${widget.user.userId}',
        data: {
          "firstName":FirstNameTfController.text,
          "fatherName": LastNameTfController.text,
          "address":AdressIfController.text,
          "birthDate":BirthDateTfController.text,
          "gender": selectedGender,
          "email":EmailTfController.text,
          "mobilePhone":PhoneNumberTfController.text,
          'userStatus':"Active",
          'institutionId':selectedHealthInstitution
        }
    ).then((value){
   if (value.statusCode == 200) {
     Toast.show("updateSuccessful".tr(), context, duration: 3);
     Navigator.pop(context);
   }
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User").tr(),
        titleSpacing: 40,

        actions: [
          IconButton(icon: Icon(Icons.update), onPressed: (){
            updateUser();
//            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          })
        ],
        elevation: 20,
        flexibleSpace: FlexibleSpaceBar.createSettings(currentExtent: 30, child: Container(
          height: 30,
        )),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: AppTheme.backgroundColor,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Text("updateUserAccount",
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Flexible(
                    child: Center(
                      child: Text("userType").tr(),
                    ),
                  ),
                  Flexible(
                    child: DropdownButton(
                      style:
                      TextStyle(color: AppTheme.inputTextColor),
                      items: _list.map((String obj) {
                        return DropdownMenuItem<String>(
                          value: obj,
                          child: Text(obj),
                        );
                      }).toList(),
                      value: selectedRole,
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
            Padding(padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Center(child: Text("healthInstitution").tr(),),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 4,
                    child: DropdownButton(
                        underline: SizedBox(),
                        style: TextStyle(
                            color: AppTheme.inputTextColor),
                        hint: Text('Select',
                          style: TextStyle(
                              fontWeight: FontWeight.bold),).tr(),
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
//            TextFormField(
//              cursorColor: AppTheme.inputTextCursorColor,
//              keyboardType: TextInputType.text,
//              autofocus: true,
//              decoration: InputDecoration(
//                  fillColor: AppTheme.textFieldBackgroundColor,
//                  icon: Icon(Icons.home)),
//              style: TextStyle(
//                color: AppTheme.inputTextColor,
//                fontSize: AppTheme.inputTextSize,
//              ),
//              controller: EmailTfController,
//              validator: (value) {
//                if (value.isEmpty) {
//                  return "Please_enter_email".tr();
//                }
//                else if (!patternEmail.hasMatch(value)) {
//                  return "enter valid email".tr();
//                } else {
//                  return null;
//                }
//              },
//            ),
//            TextFormField(
//              cursorColor: AppTheme.inputTextCursorColor,
//              keyboardType: TextInputType.text,
//              autofocus: true,
//              decoration: InputDecoration(
//                  fillColor: AppTheme.textFieldBackgroundColor,
//                  icon: Icon(Icons.home)),
//              style: TextStyle(
//                color: AppTheme.inputTextColor,
//                fontSize: AppTheme.inputTextSize,
//              ),
//              controller: AdressIfController,
//              validator: (value) {
//                if (value.isEmpty) {
//                  return "Please_enter_address".tr();
//                }
//                else if (!alphabetsOnly.hasMatch(value)) {
//                  return "enter valid address".tr();
//                } else {
//                  return null;
//                }
//              },
//            ),
//            Padding(
//              padding: EdgeInsets.symmetric(horizontal: 10),
//              child: Row(
//                children: [
//                  Flexible(
//                    child: Center(
//                      child: Text("User_type").tr(),
//                    ),
//                  ),
//                  Flexible(
//                    child: DropdownButton(
//                      style:
//                      TextStyle(color: AppTheme.inputTextColor),
//                      items: _list.map((String obj) {
//                        return DropdownMenuItem<String>(
//                          value: obj,
//                          child: Text(obj),
//                        );
//                      }).toList(),
//                      value: selectedRole,
//                      onChanged: (String val) {
//                        setState(() {
//                          selectedRole = val;
//                        });
//                      },
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Padding(padding: EdgeInsets.symmetric(horizontal: 20),
//              child: Row(
//                children: [
//                  Expanded(
//                    flex: 4,
//                    child: Center(child: Text("Health_institution").tr(),),
//                  ),
//                  Spacer(),
//                  Consumer<User>(
//                      builder: (ctx, userObj, child) {
//                        return Expanded(
//                          flex: 4,
//                          child: DropdownButton(
//                            underline: SizedBox(),
//                            style: TextStyle(
//                                color: AppTheme.inputTextColor),
//                            hint: Text('Select',
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold),).tr(),
//                            items: snapshot.data.map((
//                                HealthInstitution obj) {
//                              return DropdownMenuItem<
//                                  HealthInstitution>(
//                                value: obj,
//                                child: Text(obj.institutionName),
//                              );
//                            }).toList(),
//                            value: userObj
//                                .getSelectedHealthInstitution,
//                            onChanged: (HealthInstitution val) {
//                              Provider.of<User>(ctx, listen: false)
//                                  .updatePageState(
//                                  selectedHealthInstitution: val);
//                              selectedHealthInstitution = val;
//                              healthInstitutionIds =
//                                  val.healthInstitutionId;
//                              print(healthInstitutionIds);
//                            },
//                          ),
//                        );
//                      }
//                  ),
//                ],
//              ),
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                new Padding(
//                  padding: new EdgeInsets.all(8.0),
//                ),
//                new Text("Gender",
//                  style: new TextStyle(
//                    fontWeight: FontWeight.bold,
//                    fontSize: AppTheme.radioButtonTextSize,
//                  ),
//                ).tr(),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    new Radio(
//                      value: "Female",
//                      groupValue: selectedGender,
//                      onChanged: (String value) {
//                        setState(() {
//                          selectedGender = value;
//                        });
//                        print("prev gender: ${selectedGender}");
//                      },
//                    ),
//                    new Text("Female",
//                      style: new TextStyle(
//                        fontSize: AppTheme.radioButtonTextSize,
//                      ),
//                    ),
//                    new Radio(
//                      value: "Male",
//                      groupValue: selectedGender,
////                                      userObj.getSelectedGender,
//                      onChanged: (String value) {
//                        setState(() {
//                          selectedGender = value;
//                        });
//                      },
//                    ),
//                    new Text("Male",
//                      style: new TextStyle(
//                          fontSize: AppTheme.radioButtonTextSize),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//            DateTimeField(
//
//              format: format,
//              onShowPicker: (context, currentValue) async {
//                final date = await showDatePicker(
//                    context: context,
//                    firstDate: DateTime(1900),
//                    initialDate: currentValue ?? DateTime.now(),
//                    lastDate: DateTime(2100));
//                if (date != null) {
////                              final time = await showTimePicker(
////                                context: context,
////                                initialTime:
////                                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
////                              );
//                  return DateTimeField.combine(date,null);
//                } else {
//                  return currentValue;
//                }
//              },
//              controller: BirthDateTfController,
//              cursorColor: AppTheme.inputTextCursorColor,
//              keyboardType: TextInputType.datetime,
//              decoration: textFieldInputDecoration("Birth_date".tr()),
//              style: TextStyle(
//                color: AppTheme.inputTextColor,
//                fontSize: AppTheme.inputTextSize,
//              ),
//            ),
//
//            TextFormField(
//              cursorColor: AppTheme.inputTextCursorColor,
//              keyboardType: TextInputType.text,
//              autofocus: true,
//              decoration: InputDecoration(
//                  fillColor: AppTheme.textFieldBackgroundColor,
//                  icon: Icon(Icons.home)),
//              style: TextStyle(
//                color: AppTheme.inputTextColor,
//                fontSize: AppTheme.inputTextSize,
//              ),
//              controller:PhoneNumberTfController ,
//              maxLength: 10,
//              validator: (value) {
//                String patttern = r'(^[9][0-9]{8}$)';
//                RegExp regExp = new RegExp(patttern);
//                if (value.length == 0) {
//                  return 'Please enter mobile number'.tr();
//                } else if (!regExp.hasMatch(value)) {
//                  return 'Please enter valid mobile number'.tr();
//                } else if (value.length > 10 || value.length < 10) {
//                  return 'Please enter 9 digits only'.tr();
//                }
//                return null;
//              },
//            ),
          ],
        ),
      ),

    );
  }
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
  Future<List<HealthInstitution>> _query() async {
    print("+++++++++++++++++++++++++");
    final allRows = await healthInstitute.getInstitutionList();
    allRows.forEach((row) => print(row));
    return allRows;
  }
}
_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}