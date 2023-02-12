
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_and_adolesence/Models/User.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Widgets/snack_bar.dart';

class UploadProfile extends StatefulWidget {
  User user;
  UploadProfile(this.user);
  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  final post = User.empty();
  TextEditingController userController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedUserId;

  User user = new User.empty();
  List<User> userList = [];

  Notifier notifier;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  String fileName;

  @override
  void initState() {
    super.initState();
    getUser();
    getUserInfo();
  }

  String userType = '';
  String fullName = '';
  String userId = '';

  //image upload
  File _image;

  Future _getImage() async {
    var picker = await ImagePicker().getImage(source: ImageSource.gallery);
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      fileName = picker.path
          .split('/')
          .last;
      _image = File(picker.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Scaffold(
          body: Container(
            child: Card(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
                  child: ListView(
                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.symmetric(horizontal: 20),
//                        child: Row(
//                          children: [
//                            Expanded(
//                              flex: 3,
//                              child: Center(
//                                child: Text("mobilePhone").tr(),
//                              ),
//                            ),
//                            Spacer(),
//                            Expanded(
//                              flex: 4,
//                              child: Container(
//                                child: DropdownButtonFormField(
//                                  hint: Text(
//                                    "mobilePhone",
//                                  ).tr(),
//                                  validator: (term) =>
//                                  term == null ? "enterMobilePhone".tr() : null,
//                                  decoration: InputDecoration(
//                                    isDense: true,
//                                    prefixIcon: Icon(
//                                      FontAwesomeIcons.objectGroup,
//                                      color: Theme
//                                          .of(context)
//                                          .primaryColor,
//                                    ),
//                                    contentPadding: EdgeInsets.fromLTRB(
//                                        5, 0, 5, 0),
//                                    border: OutlineInputBorder(),
//                                    filled: false,
//                                  ),
//                                  items: userList
//                                      .map((value) =>
//                                      DropdownMenuItem(
//                                        child: Text(value.mobilePhone),
//                                        value: value.userId,
//                                      ))
//                                      .toList(),
//                                  onChanged: (val) {
//                                    setState(() {
//                                      selectedUserId = val;
//                                    });
//                                  },
//                                  value: selectedUserId,
//                                ),
//                              ),
//                            ),
//
//                          ],
//                        ),
//                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Container(
//                                  height: MediaQuery.of(context).size.height*0.1,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.2,
                                child: Text("selectProfile").tr()),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.3,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.2,
                              child: RaisedButton.icon(
                                onPressed: _getImage,
                                color: Colors.white30,
                                icon: _image == null
                                    ? Icon(
                                  FontAwesomeIcons.image,
                                )
                                    : Image.file(_image),
                                label: Text("profile").tr(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppTheme.deviderHeight,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                      20.0)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.redAccent,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 20),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                      20.0)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {}
                                _insert();

                              },
                              color: Colors.green,
                              child: Text(
                                "uploadProfile",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 2 * AppTheme.deviderHeight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void _insert() async {
    FormData formData = new FormData.fromMap({
      "userId": widget.user.userId,
      "profilePicture": MultipartFile.fromBytes(_image.readAsBytesSync(), filename: fileName),
      "createdBy": userId
    });
//    print("form data $formData");
    await dio.post("/accounts/uploadprofile", data: formData).then((response) {
      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
      print(response);
    }).catchError((error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Container(
          child: Text('Error'),
        ),
      ));
      print(error);
    });
  }
  getUserInfo() async {
    var userInfo = await SharedPreferences.getInstance();
    userType = userInfo.get("userType");
    fullName = userInfo.get("fullName");
    userId = userInfo.get("userId");
  }
  void getUser() {
    Future<List<User>> userListFuture = user.queryAllRows();
    userListFuture.then((userList) {
      setState(() {
        this.userList = userList;
      });
    });
  }
}