import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Models/User.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/request_response.dart';
import 'package:youth_and_adolesence/Screens/Users/userInfo.dart';
import 'package:youth_and_adolesence/Screens/Users/verify_professional.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
class UsersIndex extends StatefulWidget{
  @override
  _UsersIndexState createState() => _UsersIndexState();
}
class _UsersIndexState extends State<UsersIndex> {
  final user = User.instance;
  bool isPressed = false;
  String activated = "inActive";
  List<Map<String, dynamic>> users = new List<Map<String, dynamic>>();
  bool switchControl = false;
  var textHolder = 'Switch is OFF';
  bool value;
  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        textHolder = 'Switch is ON';
      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.
    }
    else {
      setState(() {
        switchControl = false;
        textHolder = 'Switch is OFF';
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }
  @override
  void initState() {
    //update state later
    _query();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _query(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
//        print(snapshot.data.length);// AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading").tr());
        } else {
          if (snapshot.hasError)
            return Center(child: Text("Server_error").tr());
          else
            return Scaffold(
              appBar: AppBar(
                title: Text("Users").tr(),
                actions: [
                                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RequestResponseScreen()));
                      }),
                ],
              ),
              body: Container(
                color: Colors.transparent,
                child: ListView(
                    children: snapshot.data.map((obj){
                        return Card(
                            child: ListTile(

                          onTap: () =>{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserInfo(user:obj))),
                          },
                          subtitle: Text('${obj.mobilePhone} ${obj.email}'),
                          leading: Icon(Icons.person,),
                          title: Text('${obj.firstName} ${obj.fatherName}'),
                          trailing: Container(
                            height: MediaQuery.of(context).size.height*0.1,
                          width: MediaQuery.of(context).size.width*0.25,
                          child: Row(
                            children:[
                              Switch(
                                value: obj.userStatus == 'Active' ? true : false,
                                onChanged:(value){

                                  setState(() {
                                    switchControl=value;

                                  });
//                                  if(switchControl==true) {
//                                    switchControl=false;
                                    statusChange(obj.userId);
//                                  }
                                },
                      activeColor: Colors.blue,
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      ),
//                              PopupMenuButton<String>(
//                              onSelected: handleClick,
//                                itemBuilder: (BuildContext cxt) {
//                                  return {'edit', 'delete',}.map((
//                                      String choice) {
//                                    var translated = (choice);
//                                    if (translated == null)
//                                      translated = choice;
//                                    return PopupMenuItem<String>(
//                                      value: choice,
//                                      child: Text(translated),
//                                    );
//                                  }).toList();
//                                },
//                              ),
//                              PopupMenuButton<String>(
//                                onSelected: handleClick,
//                                itemBuilder: (BuildContext cxt) {
//                                  return {'English', 'Amharic', 'Tigrigna', 'Oromiffa', /*'Logout', 'Settings'*/}.map((String choice) {
//                                    var translated= choice;
//                                    if(translated==null)
//                                      translated=choice;
//                                    return PopupMenuItem<String>(
//                                      value: choice,
//                                      child: Text(translated),
//                                    );
//                                  }).toList();
//                                },
//                              ),
//                              IconButton(icon: Icon(Icons.check_circle,color:(obj.userStatus=="Active")? Color(0xff00ff00)
//                                  : Color(0xffff0000)), onPressed:(){
//                                {
//                                  setState(() {
//                                    isPressed= !isPressed;
//
//                                  });
//                                  statusChange(obj.userId);
//                                }
//                              }),
                      ((obj.professionalyVerified!="Active")&&(obj.userType=="Health professional"))?RaisedButton(
                      onPressed: () {

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VerifyProfessional(user:obj)));
                      },
                          child:  Text("verify",style: TextStyle(fontSize: 10),),
                      ):Text(""),

                      ],
                      ),
                      )));
                      }).toList()),
              ),
            );
        }
      },
    );
  }
  static void handleClick(String value) {

  }
  void statusChange(String userId){
    if (switchControl == false) {
//      setState(() {
//        switchControl = false;
////        textHolder = 'Switch is ON';
//      });
      activated="inActive";
    }
    else {
//      setState(() {
//        switchControl = true;
////        textHolder = 'Switch is OFF';
//      });
      activated="Active";
//      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
    print("isPressed is=$switchControl");
      dio.put('/account/changestatus/${userId}',
      data: {
        "userStatus":activated
      }
      ).then((value) {
        _query();
      });
    }
  
 void userDetail(User obj){
    UserInfo(user: obj);
 }
  Future<List<User>> _query() async {

    final allRows = await user.queryAllRows();
    allRows.forEach((row) => print(row));
    return allRows;
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      User.columnId: 1,
//      User.columnName : 'Row 1 edited',
//      User.columnDescription  : 'Row 1 edited desc'
    };
//    final rowsAffected = await user.update(row);
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
//    final id = await user.queryRowCount();
//    final rowsDeleted = await user.delete(id);
  }
}