import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Providers/app_state.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var emailC = new TextEditingController();
  var passwordC = new TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isProcessing = false;
  bool obscurePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
      Expanded(
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 50.0),
        Container(
        width: 120,
        height: 70,
        margin: EdgeInsets.only(top: 0.0),
        alignment: Alignment.center,
        child: Text("Adolescence and Youth App ",
        style: TextStyle(fontSize: 24)),
      ),
      Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10.0),
//              Stack(
//                children: <Widget>[
//                  Positioned(
//                    left: 20.0,
//                    top: 15.0,
//                    child: Container(
//                      decoration: BoxDecoration(
//                          color: AppTheme.primaryColor,
//                          borderRadius: BorderRadius.circular(20.0)),
//                      width: 70.0,
//                      height: 20.0,
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(left: 32.0),
//                    child: Text(
//                      "signIn",
//                      style: TextStyle(
//                          fontSize: 30.0, fontWeight: FontWeight.bold),
//                    ).tr(),
//                  ),
//                ],
//              ),
              const SizedBox(height: 30.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextFormField(
                  controller: emailC,
                  validator: (term) {
                    if (term.isEmpty) {
                      return "enterUsername".tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "email".tr(), hasFloatingPlaceholder: true),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextFormField(
                  obscureText: obscurePass,
                  controller: passwordC,
                  validator: (term) {
                    if (term.isEmpty) {
                      return "enterPassword".tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "password".tr(),
                    hasFloatingPlaceholder: true,
                    suffixIcon: obscurePass
                        ? IconButton(
                            icon: Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obscurePass = !obscurePass;
                              });
                            })
                        : IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscurePass = !obscurePass;
                              });
                            },
                          ),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(right: 16.0),
                  alignment: Alignment.centerRight,
                  child: Text("Forgot your password?")),
//              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
//              Align(
//                alignment: Alignment.centerRight,
//                child: RaisedButton(
//                  padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
//                  color: AppTheme.primaryColor,
//                  elevation: 0,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(30.0),
//                          bottomLeft: Radius.circular(30.0))),
//                  onPressed: () {
//                    login();
//                  },
//                  child: Row(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      isProcessing
//                          ? CircularProgressIndicator()
//                          : Text(
//                              "signIn".tr().toUpperCase(),
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold, fontSize: 16.0),
//                            ),
//                      const SizedBox(width: 40.0),
//                      Icon(
//                        FontAwesomeIcons.arrowRight,
//                        size: 18.0,
//                      )
//                    ],
//                  ),
//                ),
//              ),
//              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//              Align(
//                alignment: Alignment.centerRight,
//                child: RaisedButton(
//                  padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
//                  color: AppTheme.primaryColor,
//                  elevation: 0,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(30.0),
//                          bottomLeft: Radius.circular(30.0))),
//                  onPressed: () {
//                    Navigator.pushNamed(context, '/signup');
//                  },
//                  child: Row(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      Text(
//                        "signUp".tr().toUpperCase(),
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold, fontSize: 16.0),
//                      ),
//                      const SizedBox(width: 40.0),
//                      Icon(
//                        FontAwesomeIcons.arrowRight,
//                        size: 18.0,
//                      )
//                    ],
//                  ),
//                ),
//              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 10.0, right: 6.0),
                    child: RaisedButton(
                      onPressed: _clearForm,
                      child: Text(
                        "Cancel",
                      ),
                      color: Colors.red,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 50.0, top: 10.0),
                    child:  true
                        ? RaisedButton(
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context)
                          .primaryColor,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0),
                      ),
                    )
                        : CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 180,top: 20),
              child:
              Row(
                children: <Widget>[
                  OutlineButton(

                      splashColor: Theme.of(context).primaryColor,
                      highlightedBorderColor:
                      Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      color: Colors.red,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "New? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                                color:
                                Theme.of(context).primaryColor),
                          ),

                        ],
                      )
                  )
                ],
              ))
            ],
          ),
        ),
      ]))]),
    );
  }

  void login() {
    if (_formKey.currentState.validate()) {
      authenticateUser();
    }
  }


  _clearForm() {
    setState(() {
      emailC.text = "";
      passwordC.text = "";
    });
  }
  void authenticateUser() async {
    setState(() {
      isProcessing = true;
    });
    await dio.post('/auth/login',
      data: {"emailOrMobilePhone": emailC.text, "password": passwordC.text},
    ).then((value) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.token = value.data["accessToken"];
      saveUserInfo(value);
      print(value);
      setState(() {
        isProcessing = false;
      });
    }).catchError((error) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: AppTheme.danger,
          content: Container(
            child: Text(
              "checkPasswordAndUsername",
              textAlign: TextAlign.center,
            ).tr(),
          )));
      setState(() {
        isProcessing = false;
      });
    });
  }

  void saveUserInfo(Response response) async {
    if (response.data["userStatus"] == 'Active') {
      var userPref = await SharedPreferences.getInstance();
      userPref.setString("accessToken", response.data['accessToken']);
      userPref.setString("userId", response.data['userId']);
      userPref.setString("userType", response.data['userType']);
      userPref.setString("userStatus", response.data['userStatus']);
      userPref.setString("fullName", response.data['fullName']);
      userPref.setString("mobilePhone", response.data['mobilePhone']);
      userPref.setString("proPic", "proPic.jpg");
      userPref.setString("gender", response.data['gender']);
      userPref.setString("address", response.data['address']);
      userPref.setString("birthDate", response.data['birthDate']);
      userPref.setString("email", response.data['email']);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Container(
        child: Text("successful").tr(),
      )));
//      Toast.show("successful".tr(), context,
//          duration: 2, backgroundColor: AppTheme.success);
      Navigator.pushReplacementNamed(context, "/homeScreen");
    } else {
      Toast.show("pleaseVerifyFirst".tr(), context,
          duration: 5, backgroundColor: AppTheme.danger);
    }
  }
}
