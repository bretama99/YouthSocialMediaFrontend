import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youth_and_adolesence/main.dart';

class AppTheme{
  static final primaryColor = HexColor("#293d75");
  //background colors
  static final backgroundColor=HexColor("#ecf2f9");
  static final buttonColor=HexColor("#293d75");
  static final textFieldBackgroundColor=Colors.white;
  //text colors
  static final titleTextColor = Colors.cyan;
  static final inputLabelColor = Colors.grey;
  static final inputTextColor = Colors.black;
  static final textColor = Colors.grey;
  static final buttonTextColor = Colors.cyan;
  static final inputTextCursorColor = Colors.orange;
  //text sizes
  static final titleTextSize = 20.0;
  static final inputLabelSize = 15.0;
  static final inputTextSize = 15.0;
  static final textSize = 25.0;
  static final radioButtonTextSize = 16.0;

  //borders
  static final textFieldBorderColor=HexColor("#b3cce6");
  static final textFieldFocusedBorderColor=Colors.cyan;
  static final textFieldBorderRadius = 30.0;
  static final buttonTextSize = 20.0;
  //paddings
  static final textFieldContentPadding= [5.0, 20.0];
  static final deviderHeight = 10.0;

  //api
static final address = "http://192.168.56.1:8090";
static final accessTocken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI0IiwiaWF0IjoxNTk1NTc0ODk1LCJleHAiOjE1OTYxNzk2OTV9.enq71PK8bZaeVk5Kul7Xu6hNVB2JLfSxyDhPKcvcs64bIjKD4JhCxwxQ4apUvRYlrYZhHR1bb5ulLNoSlxm-_w";
}


BaseOptions options =
BaseOptions(baseUrl: 'http://192.168.56.1:8090', headers: {
  HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1IiwiaWF0IjoxNTk1NzMzMzQwLCJleHAiOjE1OTYzMzgxNDB9.YjPFQZyGPsn6_WxfBuf2R-KY0LBAxxwvQG0mCkwqdVGTFM_z3la1TvvuebPYSM9JmpoYA7tYnVU7nRmH4dblYQ"
});

//Dio dio = new Dio(options);