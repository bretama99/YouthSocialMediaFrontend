import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';

//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:youth_and_adolesence/Models/ContentCategory.dart';
import 'package:youth_and_adolesence/Models/Post.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Screens/post/display_posts.dart';
import 'package:youth_and_adolesence/Utils/AppTheme.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/widget.dart';
import 'package:youth_and_adolesence/Widgets/snack_bar.dart';

class PostCreate extends StatefulWidget {
  @override
  _PostCreateState createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
  final post = Post.empty();
  TextEditingController postDetailController = TextEditingController();
  TextEditingController postCategoryController = TextEditingController();
  TextEditingController postImageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedCategoryId;

  Category category = new Category.empty();
  List<Category> categoryList = [];

  Notifier notifier;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  String fileName;

  @override
  void initState() {
    super.initState();
    getCategory();
    getUserInfo();
  }

  String userType = '';
  String fullName = '';
  String userId = '';

  //image upload
  File _image;

  Future _getImage() async {
    var picker = await ImagePicker().getImage(source: ImageSource.gallery);

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      fileName = picker.path.split('/').last;
      _image = File(picker.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Scaffold(
          body: Container(
        child: Card(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    cursorColor: AppTheme.inputTextCursorColor,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: textFieldInputDecoration("Post detail"),
                    style: TextStyle(
                      color: AppTheme.inputTextColor,
                      fontSize: AppTheme.inputTextSize,
                    ),
                    controller: postDetailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please_enter_Detail".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: AppTheme.deviderHeight,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text("Category"),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 4,
                          child: Container(
                            child: DropdownButtonFormField(
                              hint: Text(
                                "Category",
                              ).tr(),
                              validator: (term) =>
                                  term == null ? "enterCategory".tr() : null,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Icon(
                                  FontAwesomeIcons.objectGroup,
                                  color: Theme.of(context).primaryColor,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                border: OutlineInputBorder(),
                                filled: false,
                              ),
                              items: categoryList
                                  .map((value) => DropdownMenuItem(
                                        child: Text(value.categoryName),
                                        value: value.categoryId,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedCategoryId = val;
                                });
                              },
                              value: selectedCategoryId,
                            ),
                          ),
                        ),
//                              Consumer<Post>(builder: (ctx, userObj, child) {
//                                return Expanded(
//                                  flex: 4,
//                                  child: DropdownButton(
//                                    underline: SizedBox(),
//                                    style: TextStyle(
//                                        color: AppTheme.inputTextColor),
//                                    hint: Text(
//                                      'Select',
//                                      style: TextStyle(
//                                          fontWeight: FontWeight.bold),
//                                    ).tr(),
//                                    items: snapshot.data.length == null
//                                        ? CircularProgressIndicator()
//                                        : snapshot.data
//                                            .map((obj) {
//                                            return DropdownMenuItem(
//                                              value: obj.categoryId,
//                                              child: Text(obj.categoryName),
//                                            );
//                                          }).toList(),
//
//                                    onChanged: (val) {
//                                      selectedContentCategory = val;
//                                    },
//                                    value: selectedContentCategory,
//                                  ),
//                                );
//                              }),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                        child: Container(
//                                  height: MediaQuery.of(context).size.height*0.1,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Select Image").tr()),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Expanded(
                            child: RaisedButton.icon(
                              onPressed: _getImage,
                              color: Colors.white30,
                              icon: _image == null
                                  ? Icon(
                                      FontAwesomeIcons.image,
                                    )
                                  : Image.file(_image),
                              label: Text("image").tr(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

//                            RaisedButton.icon(
//                              onPressed: () {},
//                              icon: Icon(Icons.camera_alt),
//                              label: Text('ffff'),
//                            ),

//                            Container(
//                              child: imageFile==null?FlatButton(onPressed: (){_showDialog();}, child: Icon(Icons.add_a_photo,size: 80,color: Color(0xffff2fc3),)):
//                                  Image.file(imageFile,width: 400,height: 400,),
//                            ),
//                            RaisedButton(onPressed: (){
//                              if(imageFile == null){
//
//                              }
//                            },shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(10),
//                            ),
//                            color: Color(0xffff2fc3),
//                              child: Text("Upload",style: TextStyle(fontSize: 18,color: Colors.blueGrey),),
//                            ),
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
                            Navigator.pop(context);
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
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {}
                            _insert();
                          },
                          color: Colors.green,
                          child: Text(
                            "Post",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 2 * AppTheme.deviderHeight,
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  /// Create FormData instance with a Map.
//  FormData form = FormData.fromMap(Map<String, dynamic> map) {
//    _init();
//    encodeMap(
//      map,
//          (key, value) {
//        if (value == null) return null;
//        if (value is MultipartFile) {
//          files.add(MapEntry(key, value));
//        } else {
//          fields.add(MapEntry(key, value.toString()));
//        }
//        return null;
//      },
//      encode: false,
//    );
//}
  void _insert() async {
//    print("the image is $_image");

//    print(_image.readAsBytesSync());

    FormData formData = new FormData.fromMap({
      "categoryId": selectedCategoryId,
      "postDetail": postDetailController.text,
      "postFile":
          MultipartFile.fromBytes(_image.readAsBytesSync(), filename: fileName),
      "createdBy": userId
    });
//    print("form data $formData");
    await dio.post("/post", data: formData).then((response) {
      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
      print(response);
    }).catchError((error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Container(
          child: Text('Error'),
        ),
      ));
      print(error);
    });
  }

  getUserInfo() async {
    var userInfo = await SharedPreferences.getInstance();

    userType = userInfo.get("userType");
    fullName = userInfo.get("fullName");
    userId = userInfo.get("userId");
  }

  void getCategory() {
    Future<List<Category>> categoryListFuture = category.queryAllRows();
    categoryListFuture.then((categoryList) {
      setState(() {
        this.categoryList = categoryList;
      });
    });
  }
}
