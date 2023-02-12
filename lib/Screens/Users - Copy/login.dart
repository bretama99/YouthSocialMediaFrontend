//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:dio/dio.dart';
//class SignIn extends StatefulWidget {
//  @override
//  _SignInState createState() => _SignInState();
//}
//class _SignInState extends State<SignIn> {
//Dio dio = Dio();
//  final _formKey = GlobalKey<FormState>();
//  final PasswordTfController = TextEditingController();
//  final EmailTfController = TextEditingController();
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        backgroundColor: Colors.black87,
//        appBar: AppBar(
//          automaticallyImplyLeading: true,
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () => Navigator.of(context).pushNamed("/")),
//          centerTitle: true,
//        ),
//        body: Container(
//            color: AppTheme.backgroundColor,
//            child: Form(
//                key: _formKey,
//                child: Padding(
//                    padding: EdgeInsets.fromLTRB(40.0, 30, 40.0, 0),
//                    child: ListView(children: <Widget>[
//                      Container(
//                        child: Column(
//                          children: [
//                            CircleAvatar(
//                              backgroundImage: AssetImage(
//                                "assets/images/profile.jpg",
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.fromLTRB(100, 10, 40, 30),
//                        child: Text(
//                          applic.translate(context, "Login_page"),
//                          style: TextStyle(
//                              color: AppTheme.titleTextColor,
//                              fontSize: AppTheme.titleTextSize,
//                              fontWeight: FontWeight.w800),
//                        ),
//                      ),
//                      TextFormField(
//                        cursorColor: AppTheme.inputTextCursorColor,
//                        keyboardType: TextInputType.visiblePassword,
//                        decoration: textFieldInputDecoration(
//                            applic.translate(context, "Email")),
//                        style: TextStyle(
//                          color: AppTheme.inputTextColor,
//                          fontSize: AppTheme.inputTextSize,
//                        ),
//                        controller: EmailTfController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return applic.translate(
//                                context, "Please_enter_email");
//                          }
//                          return null;
//                        },
//                      ),
//                      SizedBox(
//                        height: 20,
//                      ),
//                      TextFormField(
//                        cursorColor: AppTheme.inputTextCursorColor,
//                        keyboardType: TextInputType.visiblePassword,
//                        decoration: textFieldInputDecoration(
//                            applic.translate(context, "Password")),
//                        style: TextStyle(
//                          color: AppTheme.inputTextColor,
//                          fontSize: AppTheme.inputTextSize,
//                        ),
//                        obscureText: true,
//                        controller: PasswordTfController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return applic.translate(
//                                context, "Please_enter_password");
//                          }
//                          return null;
//                        },
//                      ),
//                      SizedBox(
//                        height: 20,
//                      ),
//                      Row(
//                        children: [
//                          Container(
//                            height: MediaQuery.of(context).size.height * 0.1,
//                            width: MediaQuery.of(context).size.width * 0.3,
//                            child: RaisedButton(
//                              onPressed: () {
//                                if (!_formKey.currentState.validate())
//                                  return;
//                                shape:
//                                new RoundedRectangleBorder(
//                                    borderRadius:
//                                        new BorderRadius.circular(20.0));
//                                       loginUser();
////                                if(loginUser()==false){
//                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
//                                },
//                              child: Text(
//                                applic.translate(context, "Login"),
//                                style: TextStyle(
//                                  color: AppTheme.buttonTextColor,
//                                  fontSize: AppTheme.buttonTextSize,
//                                ),
//                              ),
//                              color: AppTheme.buttonColor,
//                            ),
//                          ),
//                          Spacer(),
//                          Container(
//                            height: MediaQuery.of(context).size.height * 0.1,
//                            width: MediaQuery.of(context).size.width * 0.3,
//                            child: RaisedButton(
//                              onPressed: () {
//                                shape:
//                                new RoundedRectangleBorder(
//                                    borderRadius:
//                                        new BorderRadius.circular(20.0));
//                                Navigator.pushReplacementNamed(context, '/users/create');
//                              },
//                              child: Text(
//                                applic.translate(context, "Sign_up"),
//                                style: TextStyle(
//                                  color: AppTheme.buttonTextColor,
//                                  fontSize: AppTheme.buttonTextSize,
//                                ),
//                              ),
//                              color: AppTheme.buttonColor,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ])))));
//  }
//  void loginUser() async {
//    await dio.post(
//      'http://192.168.56.1:8090/auth/login',
//      data: {
//        "emailOrMobilePhone": EmailTfController.text,
//        "password": PasswordTfController.text
//      },
//    ).then((value) {
//      print(value);
//    }).catchError((error) {
//      print(error);
//    });
//  }
//}
