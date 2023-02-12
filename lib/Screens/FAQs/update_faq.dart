import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_and_adolesence/Models/faq.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class UpdateFAQ extends StatefulWidget {
  final FAQ faq;

  UpdateFAQ(this.faq);

  @override
  _UpdateFAQState createState() => _UpdateFAQState();
}

class _UpdateFAQState extends State<UpdateFAQ> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  FAQ faq = FAQ.empty();
  var _formkey = new GlobalKey<FormState>();
  var titleC = new TextEditingController();
  var answerC = new TextEditingController();
  var userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
    titleC.text = widget.faq.title;
    answerC.text = widget.faq.answer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.22,
          horizontal: MediaQuery.of(context).size.height * 0.02),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03,
              horizontal: MediaQuery.of(context).size.height * 0.03),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Center(
                      child: Chip(
                          shape: AppTheme.roundedBorderMd,
                          label: Text(
                            'updateFAQ',
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
                        controller: titleC,
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enterTitle".tr();
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
                          labelText: 'title'.tr(),
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
                        maxLines: 2,
                        onFieldSubmitted: (term) {},
                        controller: answerC,
                        validator: (term) {
                          if (term.isEmpty) {
                            return "enterAnswer".tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.clipboardCheck,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
                          ),
                          labelText: 'answer'.tr(),
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
                            if (_formkey.currentState.validate()) {
                              updateFAQ();
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

  updateFAQ() async {
    await dio.put('/faq/${widget.faq.faqId}', data: {
      "title": titleC.text,
      "answer": answerC.text,
    }).then((response) {
      if (response.statusCode == 200) Navigator.pop(context,true);
    });
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    userId = userInfo.get("userInfo");
  }
}
