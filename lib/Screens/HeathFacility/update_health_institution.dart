import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/health_institution.dart';
import 'package:youth_and_adolesence/Screens/HeathFacility/add_health_institution.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class UpdateHealthInstitution extends StatefulWidget {
  final HealthInstitution healthInstitution;

  UpdateHealthInstitution(this.healthInstitution);

  @override
  _UpdateHealthInstitutionState createState() =>
      _UpdateHealthInstitutionState();
}

class _UpdateHealthInstitutionState extends State<UpdateHealthInstitution> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _formkey = new GlobalKey<FormState>();
  var institutionNameC = new TextEditingController();
  var addressC = new TextEditingController();
  var categoryC = new TextEditingController();
  int selectedCategory;
  var userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
    institutionNameC.text = widget.healthInstitution.institutionName;
    addressC.text = widget.healthInstitution.address;
    categoryC.text = widget.healthInstitution.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("updateHealthInstitution").tr(),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.05,
              horizontal: MediaQuery.of(context).size.height * 0.03),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (term) {},
                        controller: institutionNameC,
                        maxLines: 1,
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enterInstitutionName".tr();
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
                          labelText: 'institutionName'.tr(),
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
                      height: 10,
                    ),
                    Container(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (term) {},
                        controller: addressC,
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enterAddress".tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.addressBook,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
                          ),
                          labelText: 'address'.tr(),
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
                      height: 10,
                    ),
                    Container(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (term) {},
                        controller: categoryC,
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enterCategory".tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.objectGroup,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
                          ),
                          labelText: 'category'.tr(),
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
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      child: OutlineButton.icon(
                          onPressed: () {},
                          icon: Icon(CupertinoIcons.location_solid),
                          label: Text('location').tr()),
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
                            if (_formkey.currentState.validate()) {
                              updateInstitution();
                            }
                          },
                          icon: Icon(
                            FontAwesomeIcons.save,
                            color: AppTheme.white,
                          ),
                          label: Text(
                            'update',
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

  //TODO fetch coordinates from google maps here
  updateInstitution() {
    dio.put("/health_institution/${widget.healthInstitution.institutionId}",
        data: {
          "institutionName": institutionNameC.text,
          "category": categoryC.text,
          "address": addressC.text,
          "latitude": 12.22356,
          "longitude": 34.123456,
          "createdBy": userId
        }).then((response) {
      if (response.statusCode == 200) {
        Toast.show("updateSuccessful".tr(), context);
        Navigator.pop(context, true);
      }
    }).catchError((error) {
      Toast.show("somethingWentWrongTryAgain".tr(), context,
          duration: 3, backgroundColor: AppTheme.danger);
    });
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    userId = userInfo.get("userInfo");
  }
}
