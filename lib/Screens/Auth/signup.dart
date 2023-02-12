import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  List userType = [''];
  List userTypeId = [];
  String selectedRole = 'User';
  List<String> _list = ['Professional','User'];
  final format = DateFormat("yyyy/MM/dd");
  var datePickerF = FocusNode();
  var firstNameF = FocusNode();
  var fatherNameF = FocusNode();
  var gFatherNameF = FocusNode();
  var userNameF = FocusNode();
  var emailF = FocusNode();
  var passwordF = FocusNode();
  var confirmPasswordF = FocusNode();
  var mobilePhoneF = FocusNode();
  var stateF = FocusNode();
  var cityF = FocusNode();
  var firstNameC = TextEditingController();
  var fatherNameC = TextEditingController();
  var gFatherNameC = TextEditingController();
  var userNameC = TextEditingController();
  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var confirmPasswordC = TextEditingController();
  var mobilePhoneC = TextEditingController();
  var dateController = TextEditingController();
  var stateC = TextEditingController();
  var cityC = TextEditingController();
  var birthDateC = TextEditingController();
  var addressC = TextEditingController();
  var addressF = FocusNode();
  var selectedItem;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  RegExp alphabetsOnly = RegExp(r'^[a-zA-Z]+$');
  RegExp patternEmail = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  var gender;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _signUp() async {
    var selectedIndex = userType.indexOf(selectedItem);
    FormData formData = new FormData.fromMap({
      "firstName": firstNameC.text,
      "fatherName": fatherNameC.text,
      "gender": gender,
      "birthDate": birthDateC.text,
      "email": emailC.text,
      "password": passwordC.text,
      "mobilePhone": mobilePhoneC.text,
      "userType": selectedRole,
      "address": addressC.text,
    });
    var response= await dio.post("http://192.168.56.1:8090/auth/signup", data: formData);
    if (response.statusCode == 200) {
      Toast.show("signUpSuccessful".tr(), context, duration: 3);
      Navigator.pop(context);
    }
  }
  //image upload
  File _image;
  Future _getImage() async {
    var picker = await FilePicker.getFilePath(type: FileType.custom);
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(picker);
    });
  }
  @override
  void dispose() {
    firstNameC.dispose();
    fatherNameC.dispose();
    gFatherNameC.dispose();
    userNameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    mobilePhoneC.dispose();
    dateController.dispose();
    firstNameF.dispose();
    fatherNameF.dispose();
    gFatherNameF.dispose();
    userNameF.dispose();
    emailF.dispose();
    passwordF.dispose();
    confirmPasswordF.dispose();
    passwordF.dispose();
    mobilePhoneF.dispose();
    birthDateC.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  _saveGender(String value) {
    setState(() {
      gender = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                  Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                        child: Text(
                          'Signup',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 70.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(220.0, 5.0, 0.0, 0.0),
                        child: Text(
                          '.',
                          style: TextStyle(
                              fontSize: 80.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "It's free ;)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 25.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[],
                  ),
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
                            controller: firstNameC,
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
                            controller: fatherNameC,
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
                          controller: mobilePhoneC,
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
                Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, emailF, passwordF);
                            },
                            controller: emailC,
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
                        SizedBox(height: 10.0),
                        Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, passwordF, confirmPasswordF);
                            },
                            controller: passwordC,
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
                            controller: confirmPasswordC,
                            focusNode: confirmPasswordF,
                            validator: (term) {
                              if (term.isEmpty) {
                                return "enterYourConfirmationPassword".tr();
                              } else if (term != passwordC.text) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Radio(
                              value: "Male".tr(),
                              onChanged: (value) {
                                _saveGender(value);
                              },
                              groupValue: gender,
                            ),
                            Text('male').tr(),
                            new Radio(
                              value: "Female",
                              onChanged: (value) {
                                _saveGender(value);
                              },
                              groupValue: gender,
                            ),
                            Text('female').tr(),
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
                                controller:birthDateC,
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
                        child: Row(
                          children: [
                            Flexible(
                              child: Center(
                                child: Text("userType").tr(),
                              ),
                            ),
                            Flexible(
                              child: DropdownButton(

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

                        Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
//                            onFieldSubmitted: (term) {
//                              _fieldFocusChange(
//                                  context, addressC, gFatherNameF);
//                            },

                            controller: addressC,
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
                        SizedBox(height: 10.0),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                if (gender != null) {
                                  _signUp();
                                } else {
                                  _scaffoldKey.currentState
                                      .showSnackBar(new SnackBar(
                                    content: new Text("pleaseSelectYourGender!".tr(),
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 5),
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                  ));
                                }
                              } else {
                                return null;
                              }
                            },
                            child: Text(
                              "signup".tr(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          height: MediaQuery.of(context).size.height * 0.06,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                child: Text('goBack'.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ]),
            ],
          ),
        ));
  }
}

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
