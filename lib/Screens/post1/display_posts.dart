import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_and_adolesence/Models/Comment.dart';
import 'package:youth_and_adolesence/Models/Post.dart';
import 'package:youth_and_adolesence/Screens/post/create.dart';
import 'package:youth_and_adolesence/Screens/post/post_detail.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/utility.dart';
import 'package:youth_and_adolesence/Utils/widget.dart';
import 'Constants.dart';
import 'package:easy_localization/easy_localization.dart';
class PostDisplay extends StatefulWidget {
  @override
  _PostDisplayState createState() => _PostDisplayState();
}

class _PostDisplayState extends State<PostDisplay> {
  TextEditingController commentController = TextEditingController();
  final comment = Comment.empty();
  final post = Post.empty();
  String userType='';
  String fullName ='';
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<Post> fetchedData = [];
  final _formKey = GlobalKey<FormState>();
  bool shoulBeVisible = false;
  final utility = Utility();
  @override
  void initState() {
    //todo:: get comments from local database
    super.initState();

    _query();
  }
  void choiceAction(String choice){
    if(choice == Constants.Delete){

    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: _query(), // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading").tr());
          } else {
            if (snapshot.hasError)
              return Center(child: Text("Server_error").tr());
            else
              return Scaffold(
                  appBar: AppBar(
//      leading: IconButton(
//          icon: Icon(Icons.arrow_back),
////          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()))
//      ),
                    actions: [

                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (ctx) => PostCreate(),
                                fullscreenDialog: true,
                                maintainState: true));
                          }),
                    ],
                  ),
                  body: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: Colors.blue,
                          suffixIcon: Icon(Icons.search, size: 30,),
                        ),
                      ),
                      new ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (ctx, i) =>
                              Column(
                                  children: <Widget>[
                                    Divider(color: Colors.blue,),
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.95,
                                      child: Row(

                                        children: [
                                          SizedBox(height: 40,),
                                          Image.network(
                                            'https://www.google.com/search?q=images&sxsrf=ALeKk012xqeBjsIHXNuRYp9-G1tMUSahMA:1600605054352&tbm=isch&source=iu&ictx=1&fir=L3UtNGTWhn3h6M%252C78aIM0GrmvG9rM%252C_&vet=1&usg=AI4_-kQzB431YGLZuPSKERejo-S9OmMBGg&sa=X&ved=2ahUKEwjWv8K93vfrAhXQ-6QKHeN2CfAQ9QF6BAgKEFo&biw=1366&bih=625#imgrc=a9B7raWE3PxoBM',
                                          ),

//                        Spacer(),
//                         Spacer(),
                                          new Column(children: [
                                            Row(
                                              children: [
                                                Text("     ${snapshot.data[i]
                                                    .createdBy}    ",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight
                                                          .w800,
                                                      fontSize: 20),),
                                                IconButton(icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.purple,),
                                                    onPressed: null),
                                                IconButton(icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,),
                                                  onPressed: () async {
                                                    bool shoulDelete = await showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AlertDialog(
                                                            title: Text(
                                                                'Are you sure you want to delete?'),
                                                            actions: <Widget>[
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Row(
                                                                  children: [
                                                                    RaisedButton(
                                                                        onPressed: () {
                                                                          Navigator
                                                                              .pop(
                                                                              context,
                                                                              true);
                                                                        },
                                                                        child: Text(
                                                                            'Yes')),
                                                                    RaisedButton(
                                                                        onPressed: () {
                                                                          Navigator
                                                                              .pop(
                                                                              context,
                                                                              false);
                                                                        },
                                                                        child: Text(
                                                                            ' No')),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                            actionsPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8.0),
                                                          ),
                                                    );
                                                    if (shoulDelete) {
                                                      deletePost(
                                                          snapshot.data[i]
                                                              .postId);
                                                    }
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                        "/post/display");
                                                  },),
                                              ],
                                            ),
//                    Container(
////                      height: MediaQuery.of(context).size.height*0.1,
//                      width: MediaQuery.of(context).size.width*0.6,
//                      child: ListTile(
//                        title: Text(snapshot.data[i].institutionName),
//                        subtitle: Text(snapshot.data[i].institutionName),
//                      ),
//                    ),
                                            Text("${snapshot.data[i].profession} at ${snapshot.data[i].institutionName}",
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            ),
                                          ]),
                                          Spacer(),
                                          Text("        "),
                                          PopupMenuButton<String>(
//                          onSelected: handleClick,
                                            itemBuilder: (BuildContext cxt) {
                                              return {'edit', 'delete',}.map((
                                                  String choice) {
                                                var translated = (choice);
                                                if (translated == null)
                                                  translated = choice;
                                                return PopupMenuItem<String>(
                                                  value: choice,
                                                  child: Text(translated),
                                                );
                                              }).toList();
                                            },
                                          ),

                                        ],

                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetail(
                                                        snapshot.data[i])));
                                      },

                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.9,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.25,
//                    color: Colors.blueAccent,
//                    child: new Image.asset(
//                      "assets/images/leaf.jpg",
//                      fit: BoxFit.fill,
//                    ),
                                        child:Image.network(
                                          'http://192.168.0.100/images/patient_profiles/yEd7zhCXHM54bVueXJQGU6dwDd8ZUh_jkJck.jpg',
                                        ),

//                                        decoration: BoxDecoration(
//                                          borderRadius: BorderRadius.circular(
//                                              18),
//                                          image: DecorationImage(
//
//                                              fit: BoxFit.cover
//                                          ),
//                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
//                    Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                        fullscreenDialog: true,
//                                        builder: (_) => EditContentCategory(
//                                          category: obj,
//                                        )));
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetail(
                                                        snapshot.data[i])));
                                      },
                                      child: Padding(padding: EdgeInsets
                                          .fromLTRB(15, 0, 15, 0),
                                        child: Text(snapshot.data[i].postDetail,
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              textBaseline: TextBaseline
                                                  .ideographic),),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly, children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.comment, color: Colors.blue,),
                                        onPressed: () {
//                                          Navigator.push(context,
//                                              MaterialPageRoute(
//                                                  builder: (ctx) => Comments(),
//                                                  fullscreenDialog: true,
//                                                  maintainState: true));
                                        },
                                      ),
                                      Text('${snapshot.data[i].comments.length.toString()} com'),
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up, color: Colors.green,),
                                        onPressed: () {
                                          _insertLikes(snapshot.data[i].postId);
                                        },
                                      ),
                                      Text("${snapshot.data[i].likes} likes"),
                                      IconButton(
                                        icon: Icon(Icons.report),
                                        onPressed: () {
                                          _insertReports(
                                              snapshot.data[i].postId);
                                        },
                                      ),
                                      Text('${snapshot.data[i]
                                          .reports}Reports '),

                                      Text(utility.processDate(
                                          snapshot.data[i].createdAt)),

//                    DateTime.parse(snapshot.data[i].createdAt),
                                    ]
                                    ),
                                  ]
                              )
                      ),
                    ],
                  )
              );
          }
    }
    );
  }
  deletePost(int postId) async {

    await dio.delete('/post/${postId}',
    ).then((value) => null);
  }
_insertLikes(int postId) async{
    await dio.put('/post/like',
    data: {
      "postId":postId,
      "actionType":'like'
    }).then((value) => print(value));

}
  _insertReports(int postId) async{
    await dio.put('/post/like',
        data: {
          "postId":postId,
          "actionType":'report'
        }).then((value) => print(value));

  }
  ////================Function to query All rows of the table======================
  Future<List<Post>> _query() async {
//    var userInfo = await SharedPreferences.getInstance();
//
//    userType = userInfo.get("userType");
//    fullName = userInfo.get("fullName");
//    String userId = userInfo.get('userId');
//    print(fullName);
//    print(userId);
    final allRows = await post.queryAllRows();
    allRows.forEach((row) => print(row));
    return allRows;
  }

  void _insert(Map<String, dynamic> row) async {
//    print(row);
    final id = await comment.insert(row);
    print('inserted row id: $row');
  }
}
class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  final comment = Comment.instance;
  final List<Comment> _list = <Comment>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _query();
    print('init state method');
//    _readCommentList();
  }

  _query() async {
//    print('mapppppppppppppppppp');
    var comm = await comment.queryAllRows();
    print("query ${_list[0]}");
//    comment.queryAllRows().then((value) => print(value)).catchError((error) {
////      print(error);
//    });

    for (int i = 0; i < comm.length; i++) {
      setState(() {
        _list.insert(0, comm[i]);
        print(_list);
      });
    }


  }

  @override
  void didChangeDependencies() {
    //todo::
    print('didchanged method');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    print('dispose method');
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('build method');
    setState(() {
      print('#################');
    });
    return Scaffold(
//        appBar: AppBar(
//          automaticallyImplyLeading: true,
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () => Navigator.of(context).pushNamed("/")),
////        title: Text(applic.translate(context, "main_title")),
//          centerTitle: true,
//          title: Text(
//            applic.translate(context, "Create_comment"),
//          ),
//        ),
        body: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      //reused code......
                      Row(

                        children: [
                          SizedBox(height: 70,),
                          new CircleAvatar(
                            backgroundImage: AssetImage("assets/images/medco_logo.jpg"),
                          ),
                          new Column(children: [
                            Text(
                              "brhane Tamrat gidey",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20),
                            ),
                            Text(
                              "       medco software companey!!",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15),
                            ),
//            SizedBox(height: 2.0),
//                      Text("bretama99@gmail.com"),
                          ]),
                          Spacer(),

                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(40, 0, 0, 0),),
                      TextFormField(
                        minLines: 4,
                        maxLines: 4,
                        cursorColor: AppTheme.inputTextCursorColor,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: textFieldInputDecoration("comment".tr()),
                        style: TextStyle(
                          color: AppTheme.inputTextColor,
                          fontSize: AppTheme.inputTextSize,
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please_enter_comment".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: AppTheme.deviderHeight,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0)),
                              onPressed: () {
//                          _query();
                              },
                              color: Colors.redAccent,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 20),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                            child: RaisedButton(
                              onPressed: () {
                                shape:new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0));

                                    if (_formKey.currentState.validate()) {
                                    }

                                Map<String, dynamic> row = {
                                  Comment.columnComment: nameController.text
                                };

                                _insert(row);
                                Navigator.pushReplacementNamed(
                                    context, '/comments/index');
                              },
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                  color: AppTheme.buttonTextColor,
                                  fontSize: AppTheme.buttonTextSize,
                                ),
                              ).tr(),
                              color: AppTheme.buttonColor,
                            )
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                    ],
                  )),
            )));
  }

//  _readCommentList() async{
//    List items = await comment.queryAllRows();
//    items.forEach((item) {
//      Comment commen= Comment.fromMap(item);
//      print("th   ${commen.getName}");
//    });

// }
  void _insert(Map<String, dynamic> row) async {
//    print(row);
    final id = await comment.insert(row);
    Comment added = await comment.getItem(id);
    setState(() {
      _list.insert(0, added);
    });
    print(_list[0].comment);
//    print('inserted row id: $id');
  }
}

