import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youth_and_adolesence/Models/Comment.dart';
import 'package:youth_and_adolesence/Models/Post.dart';
import 'package:youth_and_adolesence/Screens/post/create.dart';
import 'package:youth_and_adolesence/Screens/post/display_posts.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/utility.dart';

//import 'package:dio/dio.dart';
class PostDetail extends StatefulWidget {
  final Post post;

  const PostDetail(this.post);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  TextEditingController commentController = TextEditingController();
  final utility = Utility();

//  List<Comment> comment1 = <Comment>[];
  final comment = Comment.instance;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool shoulBeVisible = false;

  @override
  void initState() {
    //todo:: get comments from local database
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => PostDisplay()))),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => PostCreate(),
                          fullscreenDialog: true,
                          maintainState: true));
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(
            children: [
              new Container(
                  child: new ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (ctx, i) => Column(children: <Widget>[
                            Divider(
                              color: Colors.blue,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                new CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/userImage.png"),
                                ),
                                new Column(children: [
                                  Text(
                                    widget.post.createdBy,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "       medco software companey!!           ",
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  ),
                                ]),
                              ],
                            ),
//                          SizedBox(
//                            height: 4,
//                          ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/feedbackImage.png"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Text(
                                widget.post.postDetail,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    textBaseline: TextBaseline.ideographic),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.comment,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => Comments(),
                                              fullscreenDialog: true,
                                              maintainState: true));
                                    },
                                  ),
                                  Text('${widget.post.comments.length} com'),
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctz) => PostCreate());
                                    },
                                  ),
                                  Text('${widget.post.likes} likes'),
                                  IconButton(
                                    icon: Icon(Icons.report),
                                    onPressed: () {},
                                  ),
                                  Text('${widget.post.reports}Rep'),
                                  Text(utility
                                      .processDate(widget.post.createdAt)),
                                  Text("ago"),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Container(
                                  //                      height: 300,
                                  child: ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: widget.post.comments.length,
                                    itemBuilder: (ctx, i) => Column(children: [
                                      Row(
                                        children: [
                                          new CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/userImage.png"),
                                          ),
                                          new Row(children: [
                                            Text("       "),
                                            Text(
                                              widget.post.comments[i].createdBy,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            ),
                                          ]),
                                          Spacer(),
                                          Text(utility.processDate(widget
                                              .post.comments[i].createdAt)),
                                          IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () => editComment(
                                                  widget.post.comments[i])),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () async {
                                              bool shoulDelete =
                                                  await showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                          'Are you sure you want to delete?')
                                                      .tr(),
                                                  actions: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(
                                                        children: [
                                                          RaisedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                              child: Text('Yes')
                                                                  .tr()),
                                                          RaisedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    false);
                                                              },
                                                              child: Text(' No')
                                                                  .tr()),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  actionsPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8.0),
                                                ),
                                              );
                                              if (shoulDelete) {
                                                deleteComment(widget.post
                                                    .comments[i].commentId);
                                              }
                                              Navigator.of(context)
                                                  .pushNamed("/post/display");
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("              "),
                                          Expanded(
                                            child: Text(widget
                                                .post.comments[i].comment),
                                          )
                                        ],
                                      ),
                                    ]),
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      hintText: "Comment".tr(),
                                      suffixIcon: IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {
                                            _insert();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        PostDetail(widget.post),
                                                    fullscreenDialog: true,
                                                    maintainState: true));
                                          })),
                                  controller: commentController,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ]))),
            ],
          ),
        ));
  }

  ////==============function to edit comment=================
  void editComment(Comment obj) {
    showDialog(
        context: context,
        builder: (context) {
          return Comments(
            comments: obj,
          );
        });
//        .then((value) => value ? fetchFAQ() : null);
  }

  ////===========function to delete comment===========
  deleteComment(int commentId) async {
    await dio
        .delete(
          '/post/comment/${commentId}',
        )
        .then((value) => null);
  }

  //============function to insert Comment=============
  _insert() async {
    List<Post> fetchedData = [];
    int j = 0;
    await dio.post('/post/comment', data: {
      'postId': widget.post.postId,
      'createdBy': widget.post.createdByUserId,
      'comment': commentController.text
    }).then((value) => print(value));
  }
}

class Comments extends StatefulWidget {
  final Comment comments;

  const Comments({Key key, this.comments}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final comment = Comment.instance;

  @override
  void initState() {
    commentEditingController.text = widget.comments.comment;
    print("comment=${widget.comments.commentId}");
    updateComment();
    // TODO: implement initState
    super.initState();
  }

  updateComment() {
    dio.put('/post/comment/${widget.comments.commentId}', data: {
      "commet": commentEditingController.text,
    }).then((value) {
      print(json.decode(value.data));
      print("comment");
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController commentEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Health Institutionns").tr(),
        titleSpacing: 40,
        actions: [
          IconButton(
              icon: Icon(Icons.update),
              onPressed: () {
                updateComment();
                Navigator.of(context).pushNamed("/post/display");
              })
        ],
        elevation: 20,
        flexibleSpace: FlexibleSpaceBar.createSettings(
            currentExtent: 30,
            child: Container(
              height: 30,
            )),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: AppTheme.backgroundColor,
        child: ListView(
          children: [
            TextFormField(
              cursorColor: AppTheme.inputTextCursorColor,
              keyboardType: TextInputType.text,
              autofocus: true,
              decoration: InputDecoration(
                  fillColor: AppTheme.textFieldBackgroundColor,
                  icon: Icon(Icons.comment)),
              style: TextStyle(
                color: AppTheme.inputTextColor,
                fontSize: AppTheme.inputTextSize,
              ),
              controller: commentEditingController,
            ),
          ],
        ),
      ),
    );
  }
}
