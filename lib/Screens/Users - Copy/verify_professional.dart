
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/User.dart';
import 'package:youth_and_adolesence/Models/User.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
class VerifyProfessional extends StatefulWidget{
  final User user;
  const VerifyProfessional({Key key, this.user}) : super(key: key);
  @override
  _VerifyProfessionalState createState() => _VerifyProfessionalState();
}
class _VerifyProfessionalState extends State<VerifyProfessional>{
  final statusC = TextEditingController();
  final reasonC = TextEditingController();
  final professionC = TextEditingController();
  var statusF = FocusNode();
  var reasonF = FocusNode();
  var professionF = FocusNode();
  RegExp alphabetsOnly = RegExp(r'^[a-zA-Z]+$');
  @override
  void dispose() {
    statusC.dispose();
    reasonC.dispose();
    professionC.dispose();
  }
  String userType = '';
  String fullName = '';
  String userId = '';
  @override
  void initState() {
    _saveUser();
    // TODO: implement initState
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//                  automaticallyImplyLeading: true,
//                  leading: IconButton(
//                      icon: Icon(Icons.arrow_back),
//                      onPressed: () => Navigator.of(context).pushNamed("/")),
        centerTitle: true,
        title: Text("createUser").tr(),
      ),
//                preferredSize: Size.fromHeight(100.0),

      body: Container(
        color: AppTheme.backgroundColor,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Text("verifyProfessinals",
                    style: TextStyle(
                      color: AppTheme.titleTextColor,
                      fontSize: AppTheme.titleTextSize,
                    ),
                  ).tr(),
                ),
                Container(
                  width: 150.0,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      image:AssetImage('assets/images/userImage.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                  ),

                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('${widget.user.firstName}  ${widget.user.fatherName}'),
//                  trailing: Icon(Icons.person),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.call),
                    title: Text('${widget.user.email}'),
                    subtitle: Text(widget.user.mobilePhone),
//                  trailing: Icon(Icons.call),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading:Icon(Icons.email),
                    title: Text('${widget.user.address} '),

//                  trailing: Icon(Icons.call_to_action),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('${widget.user.userType}'),
                    subtitle: Text(widget.user.userStatus),

                    isThreeLine: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, statusF, reasonF);
                            },
                            controller: statusC,
                            focusNode: statusF,
                            validator: (term) {
                              if (term.isEmpty) {
                                return "enterStatus".tr();
                              } else if (!alphabetsOnly.hasMatch(term)) {
                                return "enterValidStatus".tr();
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "status".tr(),
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, reasonF, professionF);
                            },
                            controller: reasonC,
                            focusNode: reasonF,
//                            validator: (term) {
//                              if (term.isEmpty) {
//                                return "writeTheProfession".tr();
//                              } else if (!alphabetsOnly.hasMatch(term)) {
//                                return "writeValidProfession".tr();
//                              } else {
//                                return null;
//                              }
//                            },
                            decoration: InputDecoration(
                              labelText: "profession".tr(),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            style: TextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),

                    ],
                  ),
                ),
                Container(
                  child: TextFormField(
                    minLines: 3,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
//                            onFieldSubmitted: (term) {
//                              _fieldFocusChange(
//                                  context, addressC, gFatherNameF);
//                            },

                    controller: professionC,
                    focusNode: professionF,
                    validator: (term) {
                      if (term.isEmpty) {
                        return "enterReason".tr();
//                      } else if (!alphabetsOnly.hasMatch(term)) {
//                        return "enterValidReason".tr();
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(

                      suffixIcon: Icon(
                        FontAwesomeIcons.voicemail,
                        color: Theme.of(context).primaryColor,
                        size: 20.0,
                      ),
                      labelText: "reason".tr(),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    style: TextStyle(),
                  ),
                ),
                SizedBox(height: 20,),

                Divider(height: AppTheme.deviderHeight,),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) return;
                    _insert();

                  },
                  child: Text(
                    'verify',
                    style: TextStyle(
                      color: AppTheme.buttonTextColor,
                      fontSize: AppTheme.buttonTextSize,
                    ),
                  ),
                  color: AppTheme.buttonColor,
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
  _saveUser() async{
    var userInfo = await SharedPreferences.getInstance();
    userType = userInfo.get("userType");
    fullName = userInfo.get("fullName");
    userId = userInfo.get("userId");
  }
  void _insert() async{
    await dio.put("/accounts/verify/professional", data: {
      "userId":widget.user.userId,
      "verifiedBy":userId,
      "status":statusC.text,
      "reason":reasonC.text,
      "profession":professionC.text
    }).then((value) {
      if (value.statusCode == 200) {
        Toast.show("userVerifiedSuccessfully".tr(), context, duration: 3);
        Navigator.pop(context);
      }
    }).catchError((onError){
      print(onError);
    });
  }

}
_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}