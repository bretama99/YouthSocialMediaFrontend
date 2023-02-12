import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youth_and_adolesence/Models/assistance_request.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/add_assistance_request.dart';
import 'active_requests.dart';
import 'closed_requests.dart';

class RequestAssistanceScreen extends StatefulWidget {
  @override
  _RequestAssistanceScreenState createState() =>
      _RequestAssistanceScreenState();
}

class _RequestAssistanceScreenState extends State<RequestAssistanceScreen>
    with SingleTickerProviderStateMixin {
  AssistanceRequest assistanceRequest = new AssistanceRequest.empty();
  List<AssistanceRequest> requestList = [];
  TabController _tabController;
  var _tabKey = GlobalKey<State>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("myRequests").tr(),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_circle), onPressed: () => addRequest())
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  FontAwesomeIcons.react,
                ),
                child: Text("activeRequests").tr(),
              ),
              Tab(
                child: Text("closedRequests").tr(),
                icon: Icon(FontAwesomeIcons.windowClose),
              ),
            ],
          ),
        ),
        body: TabBarView(
            key: _tabKey,
            controller: _tabController,
            children: <Widget>[
              MyActiveRequests(),
              ClosedRequests(),
            ]));
  }

  addRequest() {
    showDialog(
        context: context,
        builder: (context) {
          return AddRequest();
        }).then((value) => _tabController.previousIndex);
  }
}
