import 'package:flutter/material.dart';


class AppState with ChangeNotifier{
  String _token = '';

  get token => _token;

  set token(String token){
    _token = token;
    notifyListeners();
  }

}
