import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:youth_and_adolesence/Screens/Auth/login.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Widgets/navigation_home_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  var _visible = true;

  @override
  void initState() {
    super.initState();
    _getUserSession();
//    getCurrentAppTheme();
    requestPermission();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
  }

  requestPermission() async {
    Map<PermissionGroup, PermissionStatus> locationPermission =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.locationWhenInUse]);
  }

  _getUserSession() async {
    final userSession = await SharedPreferences.getInstance();
    var userType = userSession.getString("userType");
    var rolesId = userSession.getString("rolesId");
    var userStatus = userSession.getString("userStatus");
    debugPrint("userType" + " " + "$userType");
    if (userSession.containsKey("userType")) {
      if (userStatus == 'Active') {
        Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) => NavigationHomeScreen())));
      } else {
        Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => LoginScreen())));
      }
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => LoginScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: AppTheme.primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.1,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Icon(
                              Icons.accessibility_new,
                              size: MediaQuery.of(context).size.height * 0.1,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitChasingDots(
                      color: Colors.white,
                      size: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
//                    Text(
//                      "Transforming Ethiopian Healthcare System",
//                      style: TextStyle(color: Colors.white),
//                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Powered by",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.01),
                          child: new Image.asset(
                            'assets/images/medco_logo.png',
                            height: MediaQuery.of(context).size.height * 0.03,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
