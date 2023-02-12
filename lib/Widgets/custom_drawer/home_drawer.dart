import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../Utils/app_theme.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  var userType = '';
  var proPic = '';
  var fullName = '';

  @override
  void initState() {
    addUsersDrawer();
    super.initState();
  }

  void superAdminDrawerSet() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'home'.tr(),
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.User_Management,
        labelName: 'users'.tr(),
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.PostDisplay,
        labelName: 'Post'.tr(),
        icon: Icon(Icons.photo),
      ),
      DrawerList(
        index: DrawerIndex.Health_Facility,
        labelName: 'Institutions'.tr(),
        icon: Icon(FontAwesomeIcons.solidHospital),
      ),
      DrawerList(
        index: DrawerIndex.FAQ,
        labelName: 'faq'.tr(),
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Category,
        labelName: 'category'.tr(),
        icon: Icon(FontAwesomeIcons.objectGroup),
      ),

      DrawerList(
        index: DrawerIndex.Questions,
        labelName: 'questions'.tr(),
        icon: Icon(Icons.date_range),
      ),
      DrawerList(
        index: DrawerIndex.My_Score,
        labelName: 'myScore'.tr(),
        icon: Icon(Icons.receipt),
      ),
      DrawerList(
        index: DrawerIndex.Question_Bank,
        labelName: 'questionBank'.tr(),
        icon: Icon(Icons.folder),
      ),
      DrawerList(
        index: DrawerIndex.Chat,
        labelName: 'chat'.tr(),
        icon: Icon(Icons.chat),
      ),
      DrawerList(
          index: DrawerIndex.Help,
          labelName: 'help'.tr(),
          icon: Icon(
            FontAwesomeIcons.handsHelping,
            size: 10,
          )),
      DrawerList(
        index: DrawerIndex.Request_Response,
        labelName: 'helpResponse'.tr(),
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'feedback'.tr(),
        icon: Icon(FontAwesomeIcons.reply),
      ),
//      DrawerList(
//        index: DrawerIndex.Invite,
//        labelName: 'inviteFriend'.tr(),
//        icon: Icon(CupertinoIcons.share_up),
//      ),
//      DrawerList(
//        index: DrawerIndex.Share,
//        labelName: 'rateTheApp'.tr(),
//        icon: Icon(Icons.share),
//      ),
//      DrawerList(
//        index: DrawerIndex.Settings,
//        labelName: 'setting'.tr(),
//        icon: Icon(Icons.settings),
//      ),
      DrawerList(
        index: DrawerIndex.Profile,
        labelName: 'profile'.tr(),
        icon: Icon(Icons.person_outline),
      ),
//      DrawerList(
//        index: DrawerIndex.About,
//        labelName: 'aboutUs'.tr(),
//        icon: Icon(Icons.info),
//      ),
    ];
  }

  void adminDrawerSet() {

    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'home'.tr(),
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.User_Management,
        labelName: 'users'.tr(),
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.PostDisplay,
        labelName: 'Post'.tr(),
        icon: Icon(Icons.photo),
      ),
      DrawerList(
        index: DrawerIndex.Health_Facility,
        labelName: 'Institutions'.tr(),
        icon: Icon(FontAwesomeIcons.solidHospital),
      ),
      DrawerList(
        index: DrawerIndex.FAQ,
        labelName: 'faq'.tr(),
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Category,
        labelName: 'category'.tr(),
        icon: Icon(FontAwesomeIcons.objectGroup),
      ),

      DrawerList(
        index: DrawerIndex.Questions,
        labelName: 'questions'.tr(),
        icon: Icon(Icons.date_range),
      ),
      DrawerList(
        index: DrawerIndex.My_Score,
        labelName: 'myScore'.tr(),
        icon: Icon(Icons.receipt),
      ),
      DrawerList(
        index: DrawerIndex.Question_Bank,
        labelName: 'questionBank'.tr(),
        icon: Icon(Icons.folder),
      ),
      DrawerList(
        index: DrawerIndex.Chat,
        labelName: 'chat'.tr(),
        icon: Icon(Icons.chat),
      ),
      DrawerList(
          index: DrawerIndex.Help,
          labelName: 'help'.tr(),
          icon: Icon(
            FontAwesomeIcons.handsHelping,
            size: 10,
          )),
      DrawerList(
        index: DrawerIndex.Request_Response,
        labelName: 'helpResponse'.tr(),
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'feedback'.tr(),
        icon: Icon(FontAwesomeIcons.reply),
      ),
//      DrawerList(
//        index: DrawerIndex.Invite,
//        labelName: 'inviteFriend'.tr(),
//        icon: Icon(CupertinoIcons.share_up),
//      ),
//      DrawerList(
//        index: DrawerIndex.Share,
//        labelName: 'rateTheApp'.tr(),
//        icon: Icon(Icons.share),
//      ),
//      DrawerList(
//        index: DrawerIndex.Settings,
//        labelName: 'setting'.tr(),
//        icon: Icon(Icons.settings),
//      ),
      DrawerList(
        index: DrawerIndex.Profile,
        labelName: 'profile'.tr(),
        icon: Icon(Icons.person_outline),
      ),
//      DrawerList(
//        index: DrawerIndex.About,
//        labelName: 'aboutUs'.tr(),
//        icon: Icon(Icons.info),
//      ),
    ];


//    drawerList = <DrawerList>[
//      DrawerList(
//        index: DrawerIndex.HOME,
//        labelName: 'home'.tr(),
//        icon: Icon(Icons.home),
//      ),
//      DrawerList(
//        index: DrawerIndex.Help,
//        labelName: 'help'.tr(),
//        icon: Icon(FontAwesomeIcons.handsHelping,size: 10,)
//      ),
//      DrawerList(
//        index: DrawerIndex.Request_Response,
//        labelName: 'helpResponse'.tr(),
//        isAssetsImage: true,
//        imageName: 'assets/images/supportIcon.png',
//      ),
//      DrawerList(
//        index: DrawerIndex.User_Management,
//        labelName: 'registration'.tr(),
//        icon: Icon(Icons.group),
//      ),
//      DrawerList(
//        index: DrawerIndex.UsersCreate,
//        labelName: 'registration'.tr(),
//        icon: Icon(Icons.group),
//      ),
//      DrawerList(
//        index: DrawerIndex.PostDisplay,
//        labelName: 'postdisplay'.tr(),
//        icon: Icon(Icons.group),
//      ),
//      DrawerList(
//        index: DrawerIndex.UsersIndex,
//        labelName: 'userdisplay'.tr(),
//        icon: Icon(Icons.group),
//      ),
//
//      DrawerList(
//        index: DrawerIndex.Health_Facility,
//        labelName: 'healthFacility'.tr(),
//        icon: Icon(FontAwesomeIcons.solidHospital),
//      ),
//      DrawerList(
//        index: DrawerIndex.FAQ,
//        labelName: 'faq'.tr(),
//        icon: Icon(Icons.help),
//      ),
//      DrawerList(
//        index: DrawerIndex.Category,
//        labelName: 'category'.tr(),
//        icon: Icon(FontAwesomeIcons.objectGroup),
//      ),
//      DrawerList(
//        index: DrawerIndex.Add_Questions,
//        labelName: 'questions'.tr(),
//        icon: Icon(Icons.date_range),
//      ),
//      DrawerList(
//        index: DrawerIndex.Invite,
//        labelName: 'inviteFriend'.tr(),
//        icon: Icon(CupertinoIcons.share_up),
//      ),
//      DrawerList(
//        index: DrawerIndex.Share,
//        labelName: 'rateTheApp'.tr(),
//        icon: Icon(Icons.share),
//      ),
//      DrawerList(
//        index: DrawerIndex.About,
//        labelName: 'aboutUs'.tr(),
//        icon: Icon(Icons.info),
//      ),
//    ];
  }

  void healthProfessionalDrawerSet() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'home'.tr(),
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Request_Response,
        labelName: 'helpResponse'.tr(),
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.Chat,
        labelName: 'chat'.tr(),
        icon: Icon(Icons.chat),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'inviteFriend'.tr(),
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: 'rateTheApp'.tr(),
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'aboutUs'.tr(),
        icon: Icon(Icons.info),
      ),
    ];
  }

  void endUserDrawerSet() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'home'.tr(),
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Chat,
        labelName: 'chat'.tr(),
        icon: Icon(Icons.message),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'help'.tr(),
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.Questions,
        labelName: 'questions'.tr(),
        icon: Icon(Icons.date_range),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'inviteFriend'.tr(),
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: 'rateTheApp'.tr(),
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'aboutUs'.tr(),
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60.0)),
                              child: Image.asset('assets/images/$proPic'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      fullName != null ? fullName : 'No name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'signOut'.tr(),
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: AppTheme.danger,
                ),
                onTap: () {
                  _showDialog(context);
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppTheme.accentColor,
        highlightColor: Colors.transparent,
        onTap: () {
          navigationToScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? AppTheme.primaryColor
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? AppTheme.primaryColor
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? AppTheme.nearlyBlack
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationToScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }

  void addUsersDrawer() async {
    var userInfo = await SharedPreferences.getInstance();

    userType = userInfo.get("userType");
    fullName = userInfo.get("fullName");
    proPic = userInfo.get("proPic");

    switch (userType) {
      case "Admin":
        return adminDrawerSet();
        break;
      case "Health professional":
        return healthProfessionalDrawerSet();
        break;
      case "Registered users":
        return endUserDrawerSet();
        break;
      case "Super admin":
        return superAdminDrawerSet();
        break;
      default:
    }
  }

  void deleteUserSession() async {
    var userInfo = await SharedPreferences.getInstance();
    userInfo.remove("accessToken");
    userInfo.remove("userId");
    userInfo.remove("userType");
    userInfo.remove("userStatus");
    userInfo.remove("fullName");
    userInfo.remove("mobilePhone");
    userInfo.remove("proPic");
    userInfo.remove("gender");
    userInfo.remove("address");
    userInfo.remove("birthDate");
    userInfo.remove("email");
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<bool> _showDialog(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('confirm').tr(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: new Text('logoutMessage').tr(),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: Icon(
                    CupertinoIcons.clear_thick_circled,
                    color: Colors.green,
                  ),
                  label:
                      Text("no".tr(), style: TextStyle(color: Colors.black))),
//              FlatButton(onPressed:() => Navigator.of(context).pop(false),child: Text("No",style: TextStyle(color: Colors.green),),),
//              FlatButton(onPressed:() {  Navigator.of(context).pop(false);
//                    _deleteUserSession(context);},child: Text("Yes",style: TextStyle(color: Colors.red),),),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    deleteUserSession();
                  },
                  icon: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Theme.of(context).errorColor,
                  ),
                  label: Text(
                    "yes".tr(),
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        ) ??
        false;
  }
}

enum DrawerIndex {
  HOME,
  Questions,
  PostDisplay,
  UsersIndex,
  UsersCreate,
  Add_Questions,
  Question_Bank,
  My_Score,
  Chat,
  Help,
  Request_Response,
  Settings,
  FAQ,
  Category,
  FeedBack,
  Share,
  About,
  Profile,
  User_Management,
  Health_Facility,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
