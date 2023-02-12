import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/assistance_request.dart';
import 'package:youth_and_adolesence/Models/user_assistance_request.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/requested_assistance_list.dart';


import 'request_item.dart';
import 'user_request_item.dart';

class ClosedRequests extends StatefulWidget {
  @override
  _ClosedRequestsState createState() => _ClosedRequestsState();
}

class _ClosedRequestsState extends State<ClosedRequests> {
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  UserAssistanceRequest assistanceRequest = new UserAssistanceRequest.empty();
  List<UserAssistanceRequest> requestList = [];
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
      body: ListView.builder(
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
                  "How HIV positive person can live with his families?",
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

  Future<List<UserAssistanceRequest>> getClosedRequests() async {
    requestList = await assistanceRequest.getClosedRequestList();
    return requestList;
  }

  Future fetchClosedAssistance() {
    Future<Response> res = dio.get('/assistance-request/user/$userId',
        queryParameters: {"status": ""});
    res.then((response) async {
      List<UserAssistanceRequest> fetchedList = [];
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singleRequest =
              UserAssistanceRequest.fromMapObject(response.data[i]);
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

      return getClosedRequests();
    }).catchError((error) {
      Toast.show("somethingWentWrongTryAgain".tr(), context, duration: 3);
    });

    return res;
  }

  getUserId() async {
    var userInfo = await SharedPreferences.getInstance();
    setState(() {
      userId = userInfo.get("userId");
      fetchClosedAssistance();
    });
  }
}
