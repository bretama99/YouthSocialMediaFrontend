import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_and_adolesence/Providers/app_state.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/i18/language.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youth"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: DropdownButton(
                isDense: true,
                icon: Icon(
                  Icons.language,
                  color: Colors.black,
                ),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              e.flag,
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(e.name)
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  print(val.languageCode);
                  print(EasyLocalization.of(context).supportedLocales[0]);
                  if (val.languageCode ==
                      EasyLocalization.of(context)
                          .supportedLocales[0]
                          .toString()) {
                    EasyLocalization.of(context).locale =
                        EasyLocalization.of(context).supportedLocales[0];
                  } else if (val.languageCode ==
                      EasyLocalization.of(context)
                          .supportedLocales[1]
                          .toString()) {
                    EasyLocalization.of(context).locale =
                        EasyLocalization.of(context).supportedLocales[1];
                  } else if (val.languageCode ==
                      EasyLocalization.of(context)
                          .supportedLocales[2]
                          .toString()) {
                    EasyLocalization.of(context).locale =
                        EasyLocalization.of(context).supportedLocales[2];
                  }
//                  EasyLocalization.of(context).locale = Locale(val.languageCode);
                }),
          )
        ],
      ),
      body: Center(
        child: Consumer<AppState>(
            builder: (BuildContext context, appState, Widget child) {
              return Text(appState.token);
            },
            child: Text("Blog")),
      ),
    );
  }

  getCategory() {
    dio.get('/content-category').then((value) => print(value));
  }
}
