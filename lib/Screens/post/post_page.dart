import 'package:flutter/material.dart';
class PostPageKeys {
  static final ValueKey wholePage = ValueKey("wholePage");
  static final ValueKey bannerImage = ValueKey("bannerImage");
  static final ValueKey summary = ValueKey("summary");
  static final ValueKey mainBody = ValueKey("mainBody");
}

class PostPage extends StatelessWidget {
//  final PostModel postData;

  const PostPage({Key key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("postData.title")),
      body: ListView(
          key: PostPageKeys.wholePage,
          children: <Widget>[
            _BannerImage(key: PostPageKeys.bannerImage),
            _NonImageContents(),
          ],
        ),

    );
  }
}

class _NonImageContents extends StatelessWidget {
  const _NonImageContents({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final PostModel postData = InheritedPostModel.of(context).postData;

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          _Summary(key: PostPageKeys.summary),
//          PostTimeStamp(),
//          _MainBody(key: PostPageKeys.mainBody),
//          UserDetailsWithFollow(
//            userData: postData.author,
//          ),
          SizedBox(height: 8.0),
//          PostStats(),
          CommentsList(),
        ],
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
       " InheritedPostModel.of(context).postData.imageURL, fit: BoxFit.fitWidth,"
      ),
    );
  }
}
class CommentsListKeyPrefix {
  static final String singleComment = "Comment";
  static final String commentUser = "Comment User";
  static final String commentText = "Comment Text";
  static final String commentDivider = "Comment Divider";
}

class CommentsList extends StatelessWidget {
//  const CommentsList({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final comments = [];
//    final List<CommentModel> comments =
//        InheritedPostModel.of(context).postData.comments;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.comment),
        trailing: Text("comments.length.toString()"),
        title: Text("Comments"),
        children: List<Widget>.generate(
          comments.length,
              (int index) => _SingleComment(
            key: ValueKey("${CommentsListKeyPrefix.singleComment} $index"),
            index: index,
          ),
        ),
      ),
    );
  }
}

class _SingleComment extends StatelessWidget {
  final int index;

  const _SingleComment({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final CommentModel commentData =
//    InheritedPostModel.of(context).postData.comments[index];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          UserDetailsWithFollow(
//            key: ValueKey("${CommentsListKeyPrefix.commentUser} $index"),
//            userData: commentData.user,
//          ),
          Text(
            "fhk"
          ),
          Divider(
            key: ValueKey("${CommentsListKeyPrefix.commentDivider} $index"),
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}


//backUp for post page

//child: new ListView.builder(
//itemCount: 10,
//shrinkWrap: true,
//primary: false,
//itemBuilder: (ctx,i)=>Column(
//children: <Widget>[
//Divider(color: Colors.blue,),
//GestureDetector(
//onTap: (){
//Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PostDetail()));
//},
//child: Row(
//
//children: [
//SizedBox(height: 70,),
//new CircleAvatar(
//backgroundImage: AssetImage("assets/images/profile.jpg"),
//),
//new Column(children: [
//Text(
//"brhane Tamrat gidey",
//style: TextStyle(
//color: Colors.blue,
//fontWeight: FontWeight.w800,
//fontSize: 20),
//),
//Text(
//"       medco software companey!!",
//style: TextStyle(
//color: Colors.black38,
//fontWeight: FontWeight.normal,
//fontSize: 15),
//),
//]),
//],
//),
//),
//SizedBox(
//height: 20,
//),
//GestureDetector(
//onTap: (){
//Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PostDetail()));
//},
//child: Container(
//width: 200,
//height: 300,
//color: Colors.blueAccent,
//child: new Image.asset(
//"assets/images/leaf.jpg",
//fit: BoxFit.fill,
//),
//
//),
//),
//SizedBox(
//height: 20,
//),
//GestureDetector(
//onTap: (){
//Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PostDetail()));
//},
//child: Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
//child: Text("fjqdyewtdfwetfctweyfwedwetdweftwetfdwetwettwe",style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,textBaseline: TextBaseline.ideographic),),
//),
//),
//SizedBox(height: 20,),
//Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//IconButton(
//icon: Icon(Icons.comment,color: Colors.blue,textDirection: TextDirection.rtl,),
//onPressed: () {
//Navigator.push(context,MaterialPageRoute(builder:(ctx)=> Comments(),fullscreenDialog: true,maintainState: true ));
//},
//),
//Text('15 comments'),
//IconButton(
//icon: Icon(Icons.thumb_up,color: Colors.green,),
//onPressed: () {
//showDialog(
//context: context,builder: (ctz)=> PostCreate());
//},
//),
//Text('145 likes'),
//IconButton(
//icon: Icon(Icons.report),
//onPressed: () {
//},
//),
//Text('Reports'),
//Spacer(),
//Text("1h ago"),
//]),
//]
//)
//)