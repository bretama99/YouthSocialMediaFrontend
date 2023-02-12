
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    fillColor: AppTheme.textFieldBackgroundColor,
    filled: true,
    labelText:  hintText,
    labelStyle: TextStyle(
        color: AppTheme.inputLabelColor,
        fontSize: AppTheme.inputLabelSize,
        height: 0.5
    ),
    //contentPadding: EdgeInsets.fromLTRB(AppTheme.textFieldPadding[0], AppTheme.textFieldPadding[1], AppTheme.textFieldPadding[2], AppTheme.textFieldPadding[3]),
    contentPadding: const EdgeInsets.symmetric(
        vertical: 5.0, horizontal: 20.0),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            AppTheme.textFieldBorderRadius),
        borderSide: new BorderSide(
            color: AppTheme.textFieldBorderColor)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            AppTheme.textFieldBorderRadius),
        borderSide: new BorderSide(
            color: AppTheme.textFieldFocusedBorderColor)),
  );

}
TextStyle simpleTextFieldStyle(){
  return TextStyle(
    fontSize: 16.0,
    color: Colors.white,
  );
}