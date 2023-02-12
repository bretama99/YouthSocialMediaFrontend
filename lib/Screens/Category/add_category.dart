import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Category category = Category.empty();
  var _formKey = new GlobalKey<FormState>();
  var nameC = new TextEditingController();
  var userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.23,
          horizontal: MediaQuery.of(context).size.height * 0.02),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03,
              horizontal: MediaQuery.of(context).size.height * 0.03),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Center(
                      child: Chip(
                          shape: AppTheme.roundedBorderMd,
                          label: Text(
                            'addCategory',
                            style: AppTheme.title,
                          ).tr()),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (term) {},
                        controller: nameC,
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enterCategoryName".tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.clipboard,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
                          ),
                          labelText: 'categoryName'.tr(),
                          isDense: true,
                          labelStyle: AppTheme.textLabelMd,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton.icon(
                            icon: Icon(
                              Icons.close,
                              color: AppTheme.white,
                            ),
                            color: Theme.of(context).errorColor,
                            shape: AppTheme.roundedBorderMd,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: Text(
                              'cancel',
                              style: TextStyle(
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: RaisedButton.icon(
                          color: AppTheme.success,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              addCategory();
                            }
                          },
                          icon: Icon(
                            FontAwesomeIcons.save,
                            color: AppTheme.white,
                          ),
                          label: Text(
                            'save',
                            style: TextStyle(
                              color: AppTheme.white,
                            ),
                          ),
                          shape: AppTheme.roundedBorderMd,
                        )),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addCategory() async {
    await dio.post('/category', data: {
      "categoryName": nameC.text,
      "createdBy": userId,
    }).then((response) {
      if (response.statusCode == 200) Navigator.pop(context, true);
    });
//
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    userId = userInfo.get("userId");
  }
}
