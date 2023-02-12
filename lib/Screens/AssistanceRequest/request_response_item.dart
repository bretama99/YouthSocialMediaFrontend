import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Models/request_chat.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/utility.dart';

class RequestResponseItem extends StatelessWidget {
  final RequestChat requestChat;
  final util = Utility();

  RequestResponseItem({@required this.requestChat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: <Widget>[
            Expanded(
              child: CircleAvatar(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: requestChat.profilePicture != null
                        ? Image.network(
                            "$imageUrl/profiles/${requestChat.profilePicture}")
                        : CircleAvatar(
                            child: Text('A'),
                          )),
              ),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: requestChat.createdBy != null
                          ? EdgeInsets.symmetric(vertical: 0)
                          : EdgeInsets.only(top: 10),
                      child: Text(
                        requestChat.createdBy ?? 'admin'.tr(),
                        style: AppTheme.title,
                      ),
                    ),
                    Text(requestChat.healthFacility ?? '')
                  ],
                ))
          ],
        ),
        subtitle: Column(
          children: <Widget>[
            requestChat.image != null
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      "$imageUrl/request_chat_images/${requestChat.image}",
                      fit: BoxFit.fill,
                    ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              margin: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: AppTheme.notWhite),
                  color: AppTheme.notWhite,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      requestChat.message,
                      style: AppTheme.body2,
                      textAlign: TextAlign.justify,
                      maxLines: 10,
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),
            ),
//            Container(
//              height: MediaQuery.of(context).size.height * 0.3,
////              width: MediaQuery.of(context).size.width,
//              child:
//                  requestChat.image ?? Image.asset("assets/images/userImage.png", fit: BoxFit.fill),
//            ),

            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[Text(util.processDate(requestChat.createdAt))],
            )
          ],
        ),
      ),
    );
  }
}
