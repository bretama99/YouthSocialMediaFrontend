import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig with ChangeNotifier {
  static final _databaseName = "youthApp.db";
  static final _databaseVersion = 1;
  String _accessToken;

  //getters
  static get databaseVersion => _databaseVersion;

  static get databaseName => _databaseName;

  get accessToken => _accessToken;

  set accessToken(String accessToken) {
    _accessToken = accessToken;
    notifyListeners();
  }
}
int assistanceImageQuality = 80;
double assistanceMaxHeight = 720;
double assistanceMaxWidth = 1080;
var baseUrl = "http://192.168.0.103:8090";
var imageUrl = "http://192.168.0.103/images";
// or new Dio with a BaseOptions instance.
BaseOptions options = new BaseOptions(
  baseUrl: baseUrl,
  headers: {
    Headers.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader:
        "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzNSIsImlhdCI6MTYwMDcwNTE0NywiZXhwIjoxNjAxMzA5OTQ3fQ.8RyupI0pnyK_MlqgdVvwZlGGPUExRA8O4Y1zUfKTGF0yWIe7ELg__YYtP7_c-1dMBO_WCmnASYlidrGAA0PEZg",
  },
  connectTimeout: 30000,
  receiveTimeout: 15000,
//  responseType: ResponseType.json,
//  contentType: "application/json"
);

Dio dio = new Dio(options);

getToken() async {
  var pref = await SharedPreferences.getInstance();
  return pref.get("accessToken");
}
