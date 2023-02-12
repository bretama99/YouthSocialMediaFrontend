import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:youth_and_adolesence/Providers/app_state.dart';


import 'Screens/AssistanceRequest/request_response.dart';
import 'Screens/Auth/login.dart';
import 'Screens/Auth/signup.dart';
import 'Screens/Users/create.dart';
import 'Screens/Exam/add_question.dart';
import 'Screens/Exam/exam_bank.dart';
import 'Screens/Shared/splash_screen.dart';
import 'Utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Widgets/navigation_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(
      EasyLocalization(
        path: "assets/locale",
        supportedLocales: [
          Locale('en', 'US'),
          Locale('am', 'ET'),
          Locale('or', 'IN')
        ],
        child: MyApp(),
      )
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Youth And Adolecense',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: EasyLocalization.of(context).delegates,
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: AppTheme.textTheme,
            platform: TargetPlatform.iOS,
            accentColor: Colors.orange,
            appBarTheme: AppBarTheme(

//            color: Colors.white
            )
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/addQuestion': (context) => AddQuestion(),
          '/requestResponse': (context) => RequestResponseScreen(),
          '/homeScreen': (context) => NavigationHomeScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => UsersCreate(),
          '/questionsList': (context) => ExamList(),
        },
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
