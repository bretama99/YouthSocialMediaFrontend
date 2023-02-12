import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/request_assistance.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/requested_assistance_list.dart';
import 'package:youth_and_adolesence/Screens/Category/category_list.dart';
import 'package:youth_and_adolesence/Screens/Chat/chat_home.dart';
import 'package:youth_and_adolesence/Screens/Exam/add_question.dart';
import 'package:youth_and_adolesence/Screens/Exam/exam_home.dart';
import 'package:youth_and_adolesence/Screens/Exam/exam_bank.dart';
import 'package:youth_and_adolesence/Screens/Exam/my_score.dart';
import 'package:youth_and_adolesence/Screens/FAQs/faq_list.dart';
import 'package:youth_and_adolesence/Screens/HealthProfessional/health_professional_list.dart';
import 'package:youth_and_adolesence/Screens/HeathFacility/health_institution_list.dart';
import 'package:youth_and_adolesence/Screens/Shared/feedback_screen.dart';
import 'package:youth_and_adolesence/Screens/Shared/profile.dart';
import 'package:youth_and_adolesence/Screens/Shared/settings_screen.dart';
import 'package:youth_and_adolesence/Screens/Users/create.dart';
import 'package:youth_and_adolesence/Screens/Users/index.dart';
import 'package:youth_and_adolesence/Screens/post/display_posts.dart';
import '../Screens/my_home_page.dart';
import '../Screens/Shared/invite_friend_screen.dart';
import 'custom_drawer/drawer_user_controller.dart';
import 'custom_drawer/home_drawer.dart';
import '../Utils/app_theme.dart';
import 'package:youth_and_adolesence/Screens/Dashboard/main_page.dart';
import 'package:youth_and_adolesence/Screens/post/display_posts.dart';


class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    super.initState();
    initDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexData) {
              changeIndex(drawerIndexData);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  initDrawer() async {
    var userInfo = await SharedPreferences.getInstance();
    var userType = userInfo.get("userType");

    //set initial drawer index
    switch (userType) {
      case "Admin":
        setState(() {
          drawerIndex = DrawerIndex.HOME;
        });
        break;
      default:
        setState(() {
          drawerIndex = DrawerIndex.HOME;
        });
    }

    //set initial drawer screen
    if (userType == 'Super Admin')
      setState(() {
        screenView = MainPage();
      });
    else
      setState(() {
        screenView = MainPage();
      });
  }

  void changeIndex(DrawerIndex drawerIndexData) {
    if (drawerIndex != drawerIndexData) {
      drawerIndex = drawerIndexData;
//      if (drawerIndex == DrawerIndex.HOME) {
//        setState(() {
//          screenView = PostDisplay();
//        });
        if (drawerIndex == DrawerIndex.PostDisplay) {
          setState(() {
            screenView = PostDisplay();
          });
        }
        else if (drawerIndex == DrawerIndex.HOME) {
          setState(() {
            screenView = MainPage();
          });
        }

        else if (drawerIndex == DrawerIndex.PostDisplay) {
          setState(() {
            screenView = PostDisplay();
          });
        }
         else if (drawerIndex == DrawerIndex.UsersCreate) {
            setState(() {
              screenView = UsersCreate();
            });
      } else if (drawerIndex == DrawerIndex.Questions) {
        setState(() {
          screenView = ExamHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Question_Bank) {
        setState(() {
          screenView = ExamList();
        });
      } else if (drawerIndex == DrawerIndex.Chat) {
        setState(() {
          screenView = ChatHomeScreen();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = RequestAssistanceScreen();
        });
      } else if (drawerIndex == DrawerIndex.Request_Response) {
        setState(() {
          screenView = RequestedAssistanceScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else if (drawerIndex == DrawerIndex.Settings) {
        setState(() {
          screenView = SettingsScreen();
        });
      } else if (drawerIndex == DrawerIndex.Add_Questions) {
        setState(() {
          screenView = AddQuestion();
        });
      } else if (drawerIndex == DrawerIndex.User_Management) {
        setState(() {
          screenView = UsersIndex();
        });
      } else if (drawerIndex == DrawerIndex.Health_Facility) {
        setState(() {
          screenView = HealthInstitutionList();
        });
      } else if (drawerIndex == DrawerIndex.FAQ) {
        setState(() {
          screenView = FAQList();
        });
      }
        else if (drawerIndex == DrawerIndex.UsersIndex) {
          setState(() {
            screenView = UsersIndex();
          });
        } else if (drawerIndex == DrawerIndex.Category) {
          setState(() {
            screenView = CategoryList();
          });
        }


        else if (drawerIndex == DrawerIndex.Profile) {
        setState(() {
          screenView = ProfileScreen();
        });
      }else if (drawerIndex == DrawerIndex.My_Score) {
        setState(() {
          screenView = MyScore();
        });
      } else {
        //do in your way......
      }
    }
  }
}
