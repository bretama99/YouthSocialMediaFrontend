import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/health_institution.dart';
import 'package:youth_and_adolesence/Screens/HeathFacility/update_health_institution.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class HealthInstitutionItem extends StatelessWidget {
  final HealthInstitution healthInstitution;

  HealthInstitutionItem({this.healthInstitution});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: ListTile(
          leading: Icon(FontAwesomeIcons.hospitalAlt),
          title: Text(healthInstitution.institutionName),
          onTap: () {
            updateInstitution(healthInstitution, context);
          },
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(healthInstitution.category),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(CupertinoIcons.location_solid),
                  ),
                  Text(healthInstitution.address)
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
                      healthInstitution.institutionId, context))
            ],
          ),

        ),
      ),
    );
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
                onPressed: () {
                  dio.delete('/health-institution/$id').then((res) {
                    if (res.statusCode == 200) {
                      print(res.data);
                      if (res.data == '1') {
                        Toast.show("deletionSuccessful".tr(), context,
                            backgroundColor: AppTheme.success, duration: 3);
                        Navigator.pop(context, true);
                      }
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
        });
  }

  void updateInstitution(
      HealthInstitution healthInstitution, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return UpdateHealthInstitution(healthInstitution);
        });
  }
}
