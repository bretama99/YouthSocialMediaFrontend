//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:youth_and_adolesence/Models/User.dart';
//import 'package:youth_and_adolesence/Screens/Users/upload_profile.dart';
//import 'package:youth_and_adolesence/Screens/Users/edit.dart';
//import 'package:easy_localization/easy_localization.dart';
//import 'package:youth_and_adolesence/Utils/app_config.dart';
//
//class UserInfo extends StatefulWidget {
//  final User user;
//  const UserInfo({Key key, this.user}) : super(key: key);
//
//  @override
//  _UserInfoState createState() => _UserInfoState();
//}
//
//class _UserInfoState extends State<UserInfo> {
//  initStat(){
//  }
//  bool toggleValue=false;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        actions: [
//          IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
//      Navigator.of(context).pushNamed("/users/index");
//          }),
//        ],
//      ),
//     body:  Container(
//      child:ListView(
//        children:[
//
//      Positioned(
//        width: 350.0,
//          left: 5,
//          top: MediaQuery.of(context).size.height/5,
//          child:Column(
//            children: [
//              Padding(
//                padding: const EdgeInsets.all(20.0),
//                child: Row(
//            children:[
//                GestureDetector(
//                  onTap:() {
//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadProfile(widget.user)));
//      },
//                  child: Container(
//                    width: 80.0,
//                    height: 100,
//
//                        child: Image.network(
//                          'http://192.168.56.1/profiles/${widget.user.profilePicture}',
//                          fit:BoxFit.cover,
//
//                        ),
////                  decoration: BoxDecoration(
////                    color: Colors.red,
////                    image: DecorationImage(
////                      image:AssetImage('assets/images/userImage.png'),
////                      fit: BoxFit.cover,
////                    ),
////                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
////                  ),
//
//          ),
//                ),
//        Text("    "),
//        IconButton(icon: Icon(Icons.edit,size: 30,),onPressed: () {
//          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserEdit(widget.user)));
//        }
//        ),
////             AnimatedContainer(
////               duration: Duration(milliseconds: 1000),
////               height: 40.0,
////               width: 50.0,
////               decoration: BoxDecoration(
////                 borderRadius: BorderRadius.circular(20.0),
////                 color: toggleValue ? Colors.greenAccent[100]:Colors.redAccent[100].withOpacity(0.5)
////               ),
////               child: Stack(
////                 children: [
////                   AnimatedPositioned(
////                     duration: Duration(milliseconds: 1000),
////                     curve: Curves.easeIn,
////                     top: 3.0,
////                     left: toggleValue ? 60.0:0.0,
////                     right: toggleValue ? 0.0:60.0,
////                     child: InkWell(
////                       onTap: toggleButton,
////                       child: AnimatedSwitcher(
////                         duration: Duration(milliseconds: 1000),
////                         transitionBuilder: (Widget child, Animation<double>animation){
////                           return ScaleTransition(
////                             child: child,scale: animation
////                           );
////                         },
////                         child: toggleValue ? Icon(Icons.check_circle,color: Colors.green, size: 30.0,key: UniqueKey()):
////                         Icon(Icons.remove_circle_outline,color: Colors.red,size: 30.0,key: UniqueKey())
////                       ),
////                     ),
////                   )
////                 ],
////               ),
////             ),
//              IconButton(
//                icon: Icon(Icons.delete),
//                onPressed: () async {
//                  bool shoulDelete = await showDialog(
//                    context: context,
//                    builder: (ctx) => AlertDialog(
//                      title: Text('Are you sure you want to delete?').tr(),
//                      actions: <Widget>[
//                        Container(
//                          alignment: Alignment.centerLeft,
//                          child: Row(
//                            children: [
//                              RaisedButton(
//                                  onPressed: () {
//                                    Navigator.pop(context, true);
//                                  },
//                                  child: Text('Yes').tr()),
//                              RaisedButton(
//                                  onPressed: () {
//                                    Navigator.pop(context, false);
//                                  },
//                                  child: Text(' No').tr()),
//                            ],
//                          ),
//                        ),
//                      ],
//                      actionsPadding:
//                      EdgeInsets.symmetric(
//                          horizontal: 8.0),
//                    ),
//                  );
//                  if (shoulDelete) {
//                    deleteUser(widget.user.userId);
//                  }
////                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
//                },
//                color: Colors.red,
//              ),
//        ],
//                ),
//              ),
////              ListTile(
////                leading: CircleAvatar(
////                  child: Icon(Icons.person),
////                ),
////                title: Text("${widget.user.firstName}  ${widget.user.fatherName}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,fontFamily: 'MonteSerrat',),),
////              ),
////              ListTile(
////                leading: CircleAvatar(
////                  child: Icon(Icons.phone),
////                ),
////                title: Text("${widget.user.email}  ${widget.user.mobilePhone}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,fontFamily: 'MonteSerrat',),),
////              ),
////              Card(child: ListTile(title: Text('${widget.user.firstName}  ${widget.user.fatherName}'))),
////              Card(
////                child: ListTile(
////                  leading: FlutterLogo(),
////                  title: Text('${widget.user.email}  ${widget.user.mobilePhone}'),
////                ),
////              ),
//              Card(
//                child: ListTile(
//                  leading: Icon(Icons.person),
//                  title: Text('${widget.user.firstName}  ${widget.user.fatherName}'),
////                  trailing: Icon(Icons.person),
//                ),
//              ),
//              Card(
//                child: ListTile(
//                  leading: Icon(Icons.call),
//                  title: Text('${widget.user.email}'),
//                  subtitle: Text(widget.user.mobilePhone),
////                  trailing: Icon(Icons.call),
//                ),
//              ),
//
//              Card(
//                child: ListTile(
//                  leading:Icon(Icons.email),
//                  title: Text('${widget.user.address} '),
//
////                  trailing: Icon(Icons.call_to_action),
//                ),
//              ),
//
//              Card(
//                child: ListTile(
//                 leading: Icon(Icons.camera_alt),
//                  title: Text('${widget.user.userType}'),
//                  subtitle: Text(widget.user.userStatus),
//
//                  isThreeLine: true,
//                ),
//              ),
////              Container(
////                height: MediaQuery.of(context).size.height*0.1,
////                width: MediaQuery.of(context).size.width*0.45,
////                child: ListView(
////                  children: <Widget>[
////
////                  ],
////                ),
////              ),
////              ListTile(
////                leading: CircleAvatar(
////                  child: Icon(Icons.call_to_action),
////                ),
////                title: Text("${widget.user.address}  ${widget.user.userType}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,fontFamily: 'MonteSerrat',),),
////              ),
////              Container(
////
////                child:Column(
////    children:[
////
////              Text("${widget.user.firstName}  ${widget.user.fatherName}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,fontFamily: 'MonteSerrat',),),
////              Text("${widget.user.email}  ${widget.user.mobilePhone}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,fontFamily: 'MonteSerrat',),),
////              Text("${widget.user.address}  ${widget.user.userType}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,fontFamily: 'MonteSerrat',),),
////],
////                ),
////              ),
//            ],
//          ),
////          child: Image.asset('assets/images/profile.jpg'),
////          backgroundImage: Ima,
//    ),
//          Container(
//
//          )
//    ],
//    ),
//     ),
//    );
//
//  }
//  toggleButton(){
//    setState(() {
//      toggleValue = !toggleValue;
//    });
//  }
//  deleteUser(String userId) async {
//
//    await dio.delete('/accounts/${userId}',
//
//    ).then((value) => null);
//  }
//}