import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/global.dart';
import 'package:youth_and_adolesence/Widgets/chat/widgets.dart';




class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _showBottom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
//          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MyCircleAvatar(
              imgUrl: friendsList[0]['imgUrl'],
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Ashebir Tsehaye",
                  style: Theme.of(context).textTheme.subtitle.apply(
                    color: AppTheme.white
                  ),
                  overflow: TextOverflow.clip,
                ),
//                Text(
//                  "Online",
//                  style: Theme.of(context).textTheme.subtitle.apply(
//                        color: myGreen,
//                      ),
//                )
              ],
            )
          ],
        ),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.phone),
//            onPressed: () {},
//          ),
//          IconButton(
//            icon: Icon(Icons.videocam),
//            onPressed: () {},
//          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: messages.length,
                    itemBuilder: (ctx, i) {
                      if (messages[i]['status'] == MessageType.received) {
                        return ReceivedMessagesWidget(i: i);
                      } else {
                        return SentMessageWidget(i: i);
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
//                              IconButton(
//                                  icon: Icon(Icons.face), onPressed: () {}),
                            SizedBox(width: 10,),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 12.0),
                                      hintText: "message".tr(),
                                      border: InputBorder.none),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {},
                              ),
//                              IconButton(
//                                icon: Icon(Icons.attach_file),
//                                onPressed: () {},
//                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: AppTheme.accentColor, shape: BoxShape.circle),
                        child: InkWell(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onLongPress: () {
                            setState(() {
                              _showBottom = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

