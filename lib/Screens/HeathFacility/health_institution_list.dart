import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/health_institution.dart';
import 'package:youth_and_adolesence/Screens/HeathFacility/add_health_institution.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

import 'update_health_institution.dart';

class HealthInstitutionList extends StatefulWidget {
  @override
  _HealthInstitutionListState createState() => _HealthInstitutionListState();
}

class _HealthInstitutionListState extends State<HealthInstitutionList> {
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  Future<List<HealthInstitution>> list;
  HealthInstitution healthInstitution = HealthInstitution.empty();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInstitution();
    fetchInstitutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Institutions'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                addHealth();
              }),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicator,
        onRefresh: fetchInstitutions,
        child: FutureBuilder<List<HealthInstitution>>(
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
//                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              child: ListTile(
                                leading: Icon(FontAwesomeIcons.hospitalAlt),
                                title:
                                    Text(snapshot.data[index].institutionName),
                                onTap: () {
                                  updateInstitution(
                                      snapshot.data[index], context);
                                },
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(snapshot.data[index].category),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Icon(
                                              CupertinoIcons.location_solid),
                                        ),
                                        Text(snapshot.data[index].address)
                                      ],
                                    ),
                                  ],
                                ),
                                //TODO ontap location
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: AppTheme.danger,
                                        ),
                                        onPressed: () => deleteInstitution(
                                            snapshot.data[index].institutionId,
                                            context))
                                  ],
                                ),
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

  void addHealth() {
    showDialog(
        context: context,
        builder: (context) {
          return AddHealthInstitution();
        }).then((value) => value ? fetchInstitutions() : null);
  }

  Future<List<HealthInstitution>> getInstitution() async {
    setState(() {
      list = healthInstitution.getInstitutionList();
    });

    return list;
  }

  Future fetchInstitutions() {
    Future<Response> res = dio.get('/health_institution');
    res.then((response) async {
      List<HealthInstitution> fetchedList = [];
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singleInstitution =
              HealthInstitution.fromMapObject(response.data[i]);
          fetchedList.add(singleInstitution);
          //update or insert
          HealthInstitution cached = await healthInstitution
              .getSingleInstitution(singleInstitution.institutionId);
          if (cached != null) {
            healthInstitution.updateInstitution(singleInstitution);
          } else {
            healthInstitution.insertInstitution(singleInstitution);
          }
        }

        //remove deleted tuples
        healthInstitution.removeDeletedRows(fetchedList);
        Toast.show("updated".tr(), context);
      }

      return getInstitution();
    });

    return res;
  }

  deleteInstitution(int id, BuildContext context) {
    //TODO show dialog return value utilize it after deletion and insertion for all
    showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("deleteInstitutionWarning").tr(),
            title: Text("deleteWarning").tr(),
            actions: <Widget>[
              OutlineButton.icon(
                label: Text(
                  "yes",
                  style: TextStyle(color: AppTheme.danger),
                ).tr(),
                onPressed: () async {
                  print(id);
                  dio.delete('/health_institution/$id').then((res) {
                    if (res.statusCode == 200) {
                      Toast.show("deletionSuccessful".tr(), context,
                          backgroundColor: AppTheme.success, duration: 3);
                      Navigator.pop(context, true);
                      fetchInstitutions();
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
        }).then((value) => value ? fetchInstitutions() : null);
  }

  void updateInstitution(
      HealthInstitution healthInstitution, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return UpdateHealthInstitution(healthInstitution);
        }).then((value) => value ? fetchInstitutions() : null);
  }
}
