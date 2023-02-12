import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/faq.dart';
import 'package:youth_and_adolesence/Screens/FAQs/update_faq.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class FAQItem extends StatelessWidget {
  final FAQ faq;

  FAQItem({this.faq});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onLongPress: (){
         showModalBottomSheet(context: context, builder: (context){
           return Container(
             child: Card(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: <Widget>[
                   Expanded(
                     child: RaisedButton.icon(
                       icon: Icon(
                         Icons.close,
                         color: AppTheme.white,
                       ),
                       color: Theme.of(context).errorColor,
                       shape: AppTheme.roundedBorderMd,
                       onPressed: () {
//                         Navigator.pop(context);
                         deleteFAQ(faq.faqId,context);
                      //TODO FAQ delete API
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
                              updateFAQ(faq, context);
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
                         shape: AppTheme.roundedBorderMd,
                       )),
                 ],
               ),
             ),
           );
         });
        },
        child: ExpansionTile(
          title: Text(
            faq.title,
            style: AppTheme.title,
          ),
          backgroundColor: AppTheme.notWhite,
          trailing: IconButton(icon: Icon(Icons.help), onPressed: () {}),
          children: <Widget>[
            ListTile(
              title: Text(
                faq.answer,
                style: AppTheme.body1,
                textAlign: TextAlign.justify,
              ),
              onTap: () => updateFAQ(faq, context),
            )
          ],
        ),
      ),
    );
  }

  void updateFAQ(FAQ faq, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return UpdateFAQ(faq);
        }).then((value) => value);
  }

  deleteFAQ(int id,BuildContext context) {
    //TODO show dialog return value utilize it after deletion and insertion for all
    showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("deleteFAQWarning").tr(),
            title: Text("deleteWarning").tr(),
            actions: <Widget>[
              OutlineButton.icon(
                label: Text("yes",style: TextStyle(color: AppTheme.danger),).tr(),
                onPressed: () {
                  dio.delete('/faq/$id').then((res) {
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



}
