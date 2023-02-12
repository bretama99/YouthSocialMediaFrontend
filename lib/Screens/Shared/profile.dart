import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_and_adolesence/Widgets/profile/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userId,
      userType,
      proPic,
      phoneNumber,
      gender,
      birthDate,
      address,
      firstName,
      fatherName,
      fullName,
      email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
//                avatar: CachedNetworkImageProvider(avatars[0]),
//                coverImage: CachedNetworkImageProvider(images[1]),
                title: fullName ?? 'loading',
                subtitle: userType ?? 'loading',
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "userInformation".tr(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Card(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ...ListTile.divideTiles(
                                  color: Colors.grey,
                                  tiles: [
                                    ListTile(
                                      leading: Icon(Icons.email),
                                      title: Text("email").tr(),
                                      subtitle: Text(email ?? 'loading'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.phone),
                                      title: Text("phoneNumber").tr(),
                                      subtitle: Text(phoneNumber ?? 'loading'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.date_range),
                                      title: Text("birthDate").tr(),
                                      subtitle: Text(birthDate ?? 'loading'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.assignment_ind),
                                      title: Text("gender").tr(),
                                      subtitle: Text(gender ?? 'loading'),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      leading: Icon(Icons.my_location),
                                      title: Text("location").tr(),
                                      subtitle: Text(address ?? 'loading'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text("aboutMe").tr(),
                                      subtitle: Text("aboutMeHint").tr(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
//              UserInfo(),
            ],
          ),
        ));
  }

  getUserInfo() async {
    var userInfo = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = userInfo.get("mobilePhone");
      gender = userInfo.get("gender");
      birthDate = userInfo.get("birthDate");
      address = userInfo.get("address");
      email = userInfo.get("email");
      proPic = userInfo.get('proPic');
      userType = userInfo.get('userType');
      fullName = userInfo.get("fullName");
    });
  }
}
