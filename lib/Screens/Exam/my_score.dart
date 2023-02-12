import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:youth_and_adolesence/Screens/Exam/stacked.dart';

class MyScore extends StatefulWidget {
  @override
  _MyScoreState createState() => _MyScoreState();
}

class _MyScoreState extends State<MyScore> {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  var stack = StackedBarChart.withSampleData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("myScore").tr(),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: () {},
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: stack),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            title: Column(
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                        text: "totalQuestions".tr() + ": "),
                                    TextSpan(
                                        text: "26",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                  ]),
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                        text: "correctAnswers".tr() + ": "),
                                    TextSpan(
                                        text: "22",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                  ]),
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Center(
                              child: Text.rich(
                                TextSpan(children: [
                                  TextSpan(text: "overallScore".tr() + ": "),
                                  TextSpan(
                                      text: "22",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500))
                                ]),
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
