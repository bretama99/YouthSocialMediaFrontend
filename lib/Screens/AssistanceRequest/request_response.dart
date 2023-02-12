import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'package:youth_and_adolesence/Models/request_chat.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/request_response_item.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class RequestResponseScreen extends StatefulWidget {
  final int assistanceRequestId;

  RequestResponseScreen({@required this.assistanceRequestId});

  @override
  _RequestResponseScreenState createState() => _RequestResponseScreenState();
}

class _RequestResponseScreenState extends State<RequestResponseScreen> {
  final picker = ImagePicker();
  File image;
  String fileName;
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  var messageC = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var messageF = FocusNode();
  var userId;
  var pickerFile;
  bool isUploading = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("requestResponse").tr(),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: fetchRequestReplies)
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicator,
        onRefresh: fetchRequestReplies,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: FutureBuilder(
                            future: fetchRequestReplies(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                  break;
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.error,
                                          size: 50,
                                        ),
                                        Text('Error: ${snapshot.error}'),
                                      ],
                                    ));
                                  } else {
                                    if (snapshot.data.data.length == 0) {
                                      return Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppTheme.notWhite),
                                          color: AppTheme.notWhite,
//                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.chat,
                                              size: 80,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "noMessagesYet",
                                                style: AppTheme.textLabelLg,
                                              ).tr(),
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                          itemCount: snapshot.data.data.length,
//                                    shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return RequestResponseItem(
                                              requestChat:
                                                  RequestChat.fromMapObject(
                                                      snapshot
                                                          .data.data[index]),
                                            );
                                          });
                                    }
                                  }
                                  break;
                                default:
                                  return Center(
                                      child: Container(
                                    child:
                                        Text('somethingWentWrongTryAgain').tr(),
                                  ));
                              }
                            })),
                  ),
                  Container(
                    margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                    color: Colors.grey)
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
//                              IconButton(
//                                  icon: Icon(Icons.face), onPressed: () {}),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: messageC,
                                      focusNode: messageF,
                                      decoration: InputDecoration(
                                          hintStyle: TextStyle(fontSize: 12.0),
                                          hintText: "message".tr(),
                                          border: InputBorder.none),
                                      onFieldSubmitted: (val) {
                                        messageF.unfocus();
                                      },
                                      maxLines: 2,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "enterMessage".tr();
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.photo_camera),
                                  onPressed: () => getImage('camera'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.attach_file),
                                  onPressed: () => getImage('gallery'),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        isUploading
                            ? SpinKitThreeBounce(
                                color: AppTheme.accentColor,
                                size: 20,
                              )
                            : Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: AppTheme.accentColor,
                                    shape: BoxShape.circle),
                                child: InkWell(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onTap: () => _formKey.currentState.validate()
                                      ? requestReply()
                                      : null,
                                  onLongPress: () {
                                    setState(() {
//              _showBottom = true;
                                    });
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
//      floatingActionButton: Row(
//        children: <Widget>[
//          Expanded(
//            flex: 8,
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                  child: Form(
//                    key: _formKey,
//                    child: Container(
//                      margin: EdgeInsets.only(
//                          left: MediaQuery.of(context).size.width * 0.08),
//                      child: TextFormField(
//                        maxLines: 2,
//                        style: TextStyle(color: AppTheme.white),
//                        controller: messageC,
//                        focusNode: messageF,
//                        validator: (val) {
//                          if (val.isEmpty) {
//                            return "enterMessage".tr();
//                          } else {
//                            return null;
//                          }
//                        },
//                        onFieldSubmitted: (val) {
////                        messageF.unfocus();
//                        },
//                        decoration: InputDecoration(
////                        labelStyle: TextStyle(color: Colors.white),
//                          suffixIcon: GestureDetector(
//                            onTap: () => getImage('gallery'),
//                            child: Icon(
//                              Icons.camera_alt,
//                              color: AppTheme.white,
//                            ),
//                          ),
//                          focusedBorder: OutlineInputBorder(
//                            borderSide: BorderSide(
////                            color: Theme.of(context).primaryColor,
//                              width: 1.0,
//                            ),
//                          ),
//                          hintStyle:
//                              TextStyle(fontSize: 16, color: Colors.grey[400]),
//                          hintText: 'replyResponseHint'.tr(),
//                          border: OutlineInputBorder(),
//                          contentPadding: EdgeInsets.all(10),
//                          filled: true,
//                          fillColor: AppTheme.grey,
//                        ),
//                        cursorColor: Colors.grey,
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Expanded(
//              child: Container(
//                  color: AppTheme.white,
//                  child: IconButton(
//                      icon: Icon(Icons.send),
//                      onPressed: () {
//                        if (_formKey.currentState.validate()) requestReply();
//                      }))),
//        ],
//      ),
    );
  }

  requestReply() {
    setState(() {
      isUploading = true;
    });
    MultipartFile multipartFile;
    if (image != null)
      multipartFile =
          MultipartFile.fromBytes(image.readAsBytesSync(), filename: fileName);

    var data = {
      "requestId": widget.assistanceRequestId,
      "message": messageC.text,
//      "image": "requestChat_1594975340.jpg",
      "imageFile": multipartFile,
      "createdBy": userId,
    };
    dio.post('/request-chat', data: FormData.fromMap(data)).then((response) {
      if (response.statusCode == 200) {
        messageC.text = '';
        fetchRequestReplies();
        setState(() {
          isUploading = false;
        });
      }
    }).catchError((error) {
      setState(() {
        isUploading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('somethingWentWrongTryAgain').tr(),
        backgroundColor: AppTheme.danger,
      ));
    });
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    setState(() {
      userId = userInfo.get("userId");
    });
  }

  //TODO fetch by request ID
  Future fetchRequestReplies() {
    Future<Response> res;
    setState(() {
      res = dio.get(
        '/request-chat/request/${widget.assistanceRequestId}',
      );
    });
    return res;
  }

//TODO Image picker AndroidManifest config not done

  Future getImage(String from) async {
    pickerFile = await picker.getImage(
        source: from == 'gallery' ? ImageSource.gallery : ImageSource.camera,
        imageQuality: assistanceImageQuality,
        maxHeight: assistanceMaxHeight,
        maxWidth: assistanceMaxWidth);
    setState(() {
      fileName = pickerFile.path.split('/').last;
      image = File(pickerFile.path);
    });
  }
}
