import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/faq.dart';
import 'package:youth_and_adolesence/Screens/FAQs/add_faq.dart';
import 'package:youth_and_adolesence/Screens/FAQs/update_faq.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class FAQList extends StatefulWidget {
  @override
  _FAQListState createState() => _FAQListState();
}

class _FAQListState extends State<FAQList> {
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  Future<List<FAQ>> list;
  FAQ faq = FAQ.empty();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFAQList();
    fetchFAQ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('faq').tr(),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add_circle), onPressed: () => addFAQ())
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicator,
        onRefresh: fetchFAQ,
        child: FutureBuilder<List<FAQ>>(
            future: list,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(
                        child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.error,
                          size: 28,
                        ),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ));
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: GestureDetector(
                              onLongPress: () {
                                showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            child: Card(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: RaisedButton.icon(
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: AppTheme.white,
                                                      ),
                                                      color: Theme.of(context)
                                                          .errorColor,
                                                      shape: AppTheme
                                                          .roundedBorderMd,
                                                      onPressed: () {
//                         Navigator.pop(context);
                                                        deleteFAQ(
                                                            snapshot.data[index]
                                                                .faqId,
                                                            context);
                                                      },
                                                      label: Text(
                                                        'delete',
                                                        style: TextStyle(
                                                          color: AppTheme.white,
                                                        ),
                                                      ).tr(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: RaisedButton.icon(
                                                    color: AppTheme.success,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      updateFAQ(
                                                          snapshot.data[index]);
                                                    },
                                                    icon: Icon(
                                                      FontAwesomeIcons.save,
                                                      color: AppTheme.white,
                                                    ),
                                                    label: Text(
                                                      'update',
                                                      style: TextStyle(
                                                        color: AppTheme.white,
                                                      ),
                                                    ).tr(),
                                                    shape: AppTheme
                                                        .roundedBorderMd,
                                                  )),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    .then((value) => value ? fetchFAQ() : null);
                              },
                              child: ExpansionTile(
                                title: Text(
                                  snapshot.data[index].title,
                                  style: AppTheme.title,
                                ),
                                backgroundColor: AppTheme.notWhite,
                                trailing: IconButton(
                                    icon: Icon(Icons.help), onPressed: () {}),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      snapshot.data[index].answer,
                                      style: AppTheme.body1,
                                      textAlign: TextAlign.justify,
                                    ),
                                    onTap: () =>
                                        updateFAQ(snapshot.data[index]),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  break;
                default:
                  return Center(
                      child: Container(
                    child: Text('somethingWentWrongTryAgain').tr(),
                  ));
              }
            }),
      ),
    );
  }

  void addFAQ() {
    showDialog(
        context: context,
        builder: (context) {
          return AddFAQ();
        }).then((value) => value ? fetchFAQ() : null);
  }

  Future<List<FAQ>> getFAQList() async {
    setState(() {
      list = faq.getFAQList();
    });
    return list;
  }

  Future fetchFAQ() {
    Future<Response> res = dio.get('/faq');
    res.then((response) async {
      List<FAQ> fetchedList = [];
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singleFAQ = FAQ.fromMapObject(response.data[i]);
          fetchedList.add(singleFAQ);
          //update or insert
          FAQ cached = await faq.getSingleFAQ(singleFAQ.faqId);
          if (cached != null) {
            faq.updateFAQ(singleFAQ);
          } else {
            faq.insertFAQ(singleFAQ);
          }
        }

        //remove deleted tuples
        faq.removeDeletedRows(fetchedList);
        Toast.show("updated".tr(), context);
      }

      getFAQList();
    });

    return res;
  }

  void updateFAQ(FAQ faq) {
    showDialog(
        context: context,
        builder: (context) {
          return UpdateFAQ(faq);
        }).then((value) => value ? fetchFAQ() : null);
  }

  deleteFAQ(int id, BuildContext context) {
    //TODO show dialog return value utilize it after deletion and insertion for all
    showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("deleteFAQWarning").tr(),
            title: Text("deleteWarning").tr(),
            actions: <Widget>[
              OutlineButton.icon(
                label: Text(
                  "yes",
                  style: TextStyle(color: AppTheme.danger),
                ).tr(),
                onPressed: () {
                  dio.delete('/faq/$id').then((res) {
                    if (res.statusCode == 200) {
                      Toast.show("deletionSuccessful".tr(), context,
                          backgroundColor: AppTheme.success, duration: 3);
                      Navigator.pop(context, true);
                    }
                  }).catchError((error) => {
                        Toast.show("somethingWentWrongTryAgain".tr(), context,
                            backgroundColor: AppTheme.danger, duration: 3)
                      });
                },
                icon: Icon(Icons.check_circle, color: AppTheme.danger),
              ),
              OutlineButton.icon(
                label: Text(
                  "no",
                  style: TextStyle(color: AppTheme.success),
                ).tr(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: AppTheme.success,
                ),
              ),
            ],
          );
        }).then((value) => value ? Navigator.pop(context, true) : null);
  }
}
