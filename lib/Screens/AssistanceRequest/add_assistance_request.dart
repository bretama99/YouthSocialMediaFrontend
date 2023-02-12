import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/assistance_request.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class AddRequest extends StatefulWidget {
  @override
  _AddRequestState createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Category category = new Category.empty();
  List<Category> categoryList = new List<Category>();
  var _formkey = new GlobalKey<FormState>();
  var requestDetailC = new TextEditingController();
  int selectedCategory;
  String userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.15,
          horizontal: MediaQuery.of(context).size.height * 0.02),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.05,
              horizontal: MediaQuery.of(context).size.height * 0.03),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Center(
                        child: Chip(
                            shape: AppTheme.roundedBorderMd,
                            label: Text(
                              'addRequest',
                              style: AppTheme.title,
                            ).tr()),
                      ),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (term) {},
                      controller: requestDetailC,
                      maxLines: 3,
                      validator: (term) {
                        if (term.isEmpty) {
                          return "enterDescription".tr();
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          FontAwesomeIcons.stickyNote,
                          color: Theme.of(context).primaryColor,
                          size: 20.0,
                        ),
                        labelText: 'description'.tr(),
                        isDense: true,
                        labelStyle: AppTheme.textLabelLg,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: DropdownButtonFormField(
                      hint: Text("category", style: AppTheme.textLabelSm).tr(),
                      validator: (term) =>
                          term == null ? "enterCategory".tr() : null,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(
                          FontAwesomeIcons.objectGroup,
                          color: Theme.of(context).primaryColor,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: OutlineInputBorder(),
                        filled: false,
                      ),
                      items: categoryList
                          .map((value) => DropdownMenuItem(
                                child: Text(value.categoryName),
                                value: value.categoryId,
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCategory = val;
                        });
                      },
                      value: selectedCategory,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
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
                          ).tr(),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: RaisedButton.icon(
                        color: AppTheme.success,
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            addRequest();
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: AppTheme.white,
                        ),
                        label: Text(
                          'send',
                          style: TextStyle(
                            color: AppTheme.white,
                          ),
                        ).tr(),
                        shape: AppTheme.roundedBorderMd,
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addRequest() async {
    await dio.post('/assistance-request', data: {
      "requestDetail": requestDetailC.text,
      "categoryId": selectedCategory,
      "latitude": 31.125000,
      "longitude": 10.125000,
      "createdBy": userId
    }).then((response) {
      if (response.statusCode == 200) Navigator.pop(context, true);
      Toast.show("additionSuccessful", context, duration: 2);
    }).catchError((error) {
      Toast.show("somethingWentWrongTryAgain".tr(), context, duration: 3);
    });
//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((value) async {
//      var now = new DateTime.now();
//      var newRequest = new AssistanceRequest(requestDetailC.text, selectedCategory, "DAEHO342", "BEIW973E2", "Active", "Dave", now.toIso8601String());
//      await newRequest.insertRequest(newRequest);
//      print(newRequest);
//      Navigator.pop(context,true);
//    });
  }

  void getCategory() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) async {
//      var cat1 = new Category("Corona", "Admin");
//      var cat2 = new Category("Adulthood", "Admin");
//      category.insertCategory(cat1);
//     var res = await category.insertCategory(cat2);
//     print(res);

//
//      databaseHelper.insertCategory(cat1);
//      databaseHelper.insertCategory(cat2);

      Future<List<Category>> categoryListFuture = category.getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
        });
      });
    });
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    userId = userInfo.get("userId");
  }
}
