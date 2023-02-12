import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Models/user_assistance_request.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/requested_assistance_list.dart';

import 'change_status_sheet.dart';
import 'user_request_item.dart';

class MyActiveRequests extends StatefulWidget {
  @override
  _MyActiveRequestsState createState() => _MyActiveRequestsState();
}

class _MyActiveRequestsState extends State<MyActiveRequests> {
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  UserAssistanceRequest assistanceRequest = new UserAssistanceRequest.empty();
  Future<List<UserAssistanceRequest>> requestList;
  var userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

//      RefreshIndicator(
//        key: _refreshIndicator,
//        onRefresh: fetchActiveAssistance,
//        child: FutureBuilder<List<UserAssistanceRequest>>(
//            future: getActiveAssistance(),
//            builder: (context, snapshot) {
//              switch (snapshot.connectionState) {
//                case ConnectionState.waiting:
//                  return Center(child: CircularProgressIndicator());
//                  break;
//                case ConnectionState.done:
//                  if (snapshot.hasError)
//                    return Center(
//                        child: Column(
//                      children: <Widget>[
//                        Icon(
//                          Icons.error,
//                          size: 28,
//                        ),
//                        Text('Error: ${snapshot.error}'),
//                      ],
//                    ));
//                  else
//                    return GestureDetector(
//                      onLongPress: showStatusOption,
//                      child: ListView.builder(
//                          shrinkWrap: true,
//                          itemCount: snapshot.data.length,
//                          itemBuilder: (context, index) {
//                            return UserRequestItem(snapshot.data[index]);
//                          }),
//                    );
//                  break;
//                default:
//                  return Center(
//                      child: Container(
//                    child: Text('somethingWentWrongTryAgain').tr(),
//                  ));
//              }
//            }),
//      ),
      ListView.builder(
        itemCount: 1,
        itemBuilder: (ctx, i) {
          return Column(
            children: <Widget>[
              ListTile(
                isThreeLine: true,
                onLongPress: () {},
//                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen())),
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                  backgroundColor: Colors.green,
                ),
                title: Text(
                  "Please help on how to protect my self from the sexualy transmited diseases",
                  style: Theme.of(context).textTheme.title,
                ),
                subtitle: Text(
                "STD",
                style: Theme.of(context)
                    .textTheme
                    .subtitle
                    .apply(color: Colors.black54),
              ),
                trailing: RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RequestedAssistanceScreen();
                }));
          },
          child: Text("Response"),
          color: Colors.green,
          ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }

  //TODO:Update after addition not working
  Future<List<UserAssistanceRequest>> getActiveAssistance() async {
    setState(() {
      requestList = assistanceRequest.getActiveRequestList();
    });
    return requestList;
  }

  Future fetchActiveAssistance() {
    Future<Response> res = dio.get('/assistance-request/user/$userId',
        queryParameters: {"status": ""});
    res.then((response) async {
      print(response);
      List<UserAssistanceRequest> fetchedList = [];
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singleRequest = UserAssistanceRequest.fromMapObject(response.data[i]);
          fetchedList.add(singleRequest);
          //update or insert
          UserAssistanceRequest cached = await assistanceRequest
              .getSingleAssistanceRequest(singleRequest.requestId);
          if (cached != null) {
            assistanceRequest.updateRequest(singleRequest);
          } else {
            assistanceRequest.insertRequest(singleRequest);
          }
        }

        //remove deleted tuples
        assistanceRequest.removeDeletedRows(fetchedList);
        Toast.show("updated".tr(), context);
      }

      return getActiveAssistance();
    }).catchError((error) {
      Toast.show("somethingWentWrongTryAgain".tr(), context, duration: 3);
    });

    return res;
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    setState(() {
      userId = userInfo.get("userId");
      fetchActiveAssistance();
    });
  }
  void showStatusOption() {
    List<String> actionList = ['Active', 'Closed'];
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ChangeStatusSheet(actionList);
        });
  }
}
