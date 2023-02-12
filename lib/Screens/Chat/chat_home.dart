import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/global.dart';


import 'chat.dart';

class ChatHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var professional=["Rezene Hagos(Psycologist)","Semere Tsadik(Gynaecologist)", "Halefom Desta(Psychiatrist)"];
    var Questions =["Hey! Can you help me how to use condom?","Can you tell me the tranmision ways of HIV ?", "Thank you for your help!"];
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.white,
//        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black45),
//        iconTheme: IconThemeData(color: Colors.black45),
        title: Text("message").tr(),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
//          IconButton(
//            icon: Icon(Icons.add_box),
//            onPressed: () {},
//          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: AppTheme.accentColor,
        child: Icon(Icons.add_circle),
        onPressed: () {},
      ),
//      bottomNavigationBar: buildBottomAppBar(),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (ctx, i) {
          return Column(
            children: <Widget>[
              ListTile(
                isThreeLine: true,
                onLongPress: () {},
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen())),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.3),
                          offset: Offset(0, 5),
                          blurRadius: 25)
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(friendsList[i]['imgUrl']),
                        ),
                      ),
                      friendsList[i]['isOnline']
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                title: Text(
                  "${professional[i]}",
                  style: Theme.of(context).textTheme.title,
                ),
                subtitle: Text(
                  "${Questions[i]}",
                  style: !friendsList[i]['seen']
                      ? Theme.of(context)
                          .textTheme
                          .subtitle
                          .apply(color: Colors.black87)
                      : Theme.of(context)
                          .textTheme
                          .subtitle
                          .apply(color: Colors.black54),
                ),
                trailing: Container(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          friendsList[i]['seen']
                              ? Icon(
                                  Icons.check,
                                  size: 15,
                                )
                              : Container(height: 15, width: 15),
                          Text("${friendsList[i]['lastMsgTime']}")
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      friendsList[i]['hasUnSeenMsgs']
                          ? Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${friendsList[i]['unseenCount']}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 25,
                            ),
                    ],
                  ),
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 7.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.message, color: Colors.black45),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.view_list, color: Colors.black45),
            onPressed: () {},
          ),
          SizedBox(width: 25),
          IconButton(
            icon: Icon(Icons.call, color: Colors.black45),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black45),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
