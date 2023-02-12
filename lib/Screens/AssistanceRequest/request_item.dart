import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_and_adolesence/Models/assistance_request.dart';

import 'package:youth_and_adolesence/Screens/AssistanceRequest/request_response.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/utility.dart';

class RequestItem extends StatelessWidget {
  final AssistanceRequest assistanceRequest;
  final utility = new Utility();

  RequestItem(this.assistanceRequest);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: Card(
        child: ListTile(
          title: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                            "$imageUrl/patient_profiles/${assistanceRequest.profilePicture}"),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 10),
                        child: Text(
                          assistanceRequest.createdBy.toUpperCase(),
                          style: AppTheme.title,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppTheme.notWhite),
                          color: AppTheme.notWhite,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Text(
                          assistanceRequest.requestDetail,
                          style: AppTheme.body1,
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Container(
            margin: EdgeInsets.all(1),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.location_solid),
                        label: Text('location').tr()),
                    Container(
                      decoration: BoxDecoration(
                        color: assistanceRequest.status == 'active'
                            ? AppTheme.success
                            : AppTheme.danger,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Text(
                        assistanceRequest.status,
                        style: TextStyle(color: AppTheme.white),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '#' + assistanceRequest.categoryName,
                      style: AppTheme.title,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.2),
                      child: Text(
                          utility.processDate(assistanceRequest.createdAt)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isThreeLine: true,
          onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => RequestResponseScreen(
                        assistanceRequestId: assistanceRequest.requestId,
                      ))),
        ),
      ),
    );
  }
}
