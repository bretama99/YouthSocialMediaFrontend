import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youth_and_adolesence/Models/assistance_request.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/change_status_sheet.dart';
import 'package:youth_and_adolesence/Screens/AssistanceRequest/request_item.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';
import 'package:youth_and_adolesence/Utils/database_helper.dart';

class RequestedAssistanceScreen extends StatefulWidget {
  @override
  _RequestedAssistanceScreenState createState() =>
      _RequestedAssistanceScreenState();
}

class _RequestedAssistanceScreenState extends State<RequestedAssistanceScreen> {
  List<Category> categoryList = new List<Category>();
  Category category = new Category.empty();
  DatabaseHelper databaseHelper = DatabaseHelper();
  var selectedCategory;
  var searchC = TextEditingController();
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  List<AssistanceRequest> fetchedList = [];
  DateTime _startDate;
  DateTime _endDate;
  List<DateTime> picked = [];

  bool isDateSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('requestedAssistance').tr(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => {},
          )
        ],
      ),
      body:
//      SingleChildScrollView(
//        child: RefreshIndicator(
//          key: _refreshIndicator,
//          onRefresh: () => fetchRequestedAssistance(searchC.text),
//          child: Container(
//            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//            child: Column(
//              children: <Widget>[
////                Container(
////                  child: Row(
////                    children: <Widget>[
//////                          Expanded(
//////                            child: IconButton(icon: Icon(FontAwesomeIcons.listUl), onPressed: null),
//////                          ),
////                      Expanded(
////                        flex: 10,
////                        child: Container(
////                            color: Theme.of(context).primaryColor,
////                            height: MediaQuery.of(context).size.height * 0.09,
////                            child: Center(
////                                child: Text('requestedAssistance').tr())),
////                      )
////                    ],
////                  ),
////                ),
//                Padding(
//                    padding: EdgeInsets.only(bottom: 4, left: 2),
//                    child: Row(
//                      children: <Widget>[
//                        Expanded(
//                          flex: 11,
//                          child: TextFormField(
//                            controller: searchC,
//                            textInputAction: TextInputAction.go,
//                            onChanged: (val) {
//                              fetchRequestedAssistance(searchC.text);
//                            },
//                            decoration: InputDecoration(
//                              suffixIcon: Icon(CupertinoIcons.search),
//                              hintText: 'searchUser'.tr(),
//                              contentPadding:
//                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                              fillColor: Colors.white,
//                              filled: true,
//                              border: OutlineInputBorder(
//                                borderRadius: BorderRadius.circular(10.0),
//                              ),
//                            ),
//                          ),
//                        ),
//                        Expanded(
//                            flex: 2,
//                            child: IconButton(
//                                icon: Icon(FontAwesomeIcons.filter),
//                                onPressed: showFilterDialog))
//                      ],
//                    )),
//
//                FutureBuilder(
//                    future: fetchRequestedAssistance(searchC.text),
//                    builder: (context, snapshot) {
//                      switch (snapshot.connectionState) {
//                        case ConnectionState.waiting:
//                          return Container(
//                            margin: EdgeInsets.symmetric(
//                                vertical:
//                                    MediaQuery.of(context).size.height * 0.1),
//                            child: Center(
//                              child: SpinKitDoubleBounce(
//                                color: AppTheme.accentColor,
//                                size: 80,
//                              ),
//                            ),
//                          );
//                          break;
//                        case ConnectionState.done:
//                          if (snapshot.hasError) {
//                            return Center(
//                                child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(
//                                  Icons.error,
//                                  size: 50,
//                                ),
//                                Text('Error: ${snapshot.error}'),
//                              ],
//                            ));
//                          } else {
//                            if (snapshot.data.data.length == 0) {
//                              return Container(
//                                margin: EdgeInsets.symmetric(vertical: 20),
//                                padding: EdgeInsets.all(20),
//                                decoration: BoxDecoration(
//                                  shape: BoxShape.circle,
//                                  border: Border.all(color: AppTheme.notWhite),
//                                  color: AppTheme.notWhite,
////                                          borderRadius: BorderRadius.circular(10)
//                                ),
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: <Widget>[
//                                    Icon(
//                                      FontAwesomeIcons.handsHelping,
//                                      size: 80,
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Text(
//                                        "noAssistanceRequests",
//                                        style: AppTheme.textLabelLg,
//                                      ).tr(),
//                                    )
//                                  ],
//                                ),
//                              );
//                            } else {
//                              return GestureDetector(
//                                  onLongPress: showStatusOption,
//                                  child: Container(
//                                    height: MediaQuery.of(context).size.height *
//                                        0.8,
//                                    child: Expanded(
//                                      child: ListView.builder(
//                                          itemCount: snapshot.data.data.length,
//                                          shrinkWrap: true,
//                                          itemBuilder: (context, index) {
//                                            return RequestItem(
//                                                AssistanceRequest.fromMapObject(
//                                                    snapshot.data.data[index]));
//                                          }),
//                                    ),
//                                  ));
//                            }
//                          }
//                          break;
//                        default:
//                          return Center(
//                              child: Container(
//                            child: Text('somethingWentWrongTryAgain').tr(),
//                          ));
//                      }
//                    }),
//              ],
//            ),
//          ),
//        ),
//      ),
    Container(
    child: Column(
    children: <Widget>[
    Row(
    children: <Widget>[
    Container(
    width: 10,
    ),

    ],
    ),
    Container(
    height: 10.0,
    ),
    Expanded(
    child:
    ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          TextEditingController trackingNumberController =
          TextEditingController();
//                    if (trackingNumberList[index] != null)
//          trackingNumberController.text = trackingNumberList[index];
          return Card(
              child: ListTile(
                  title: Text(
                    'Please help on how to protect my self from the sexualy transmited diseases',
                  ),
//                            leading: CircleAvatar(
//                              child: Icon(Icons.person),
//                              backgroundColor: Colors.green,
//                            ),
                  trailing: IconButton(
                    icon: Icon(Icons.done,color: Colors.blue,),
                    onPressed: () => {},
                  ),
                  subtitle: Container(
                      height: 40,
                      width: 100,
                      child: TextFormField(
//                        controller: trackingNumberController,
                        minLines: 5,
                        maxLines: 5,
                        onChanged: (value) {

                        },
                        decoration: InputDecoration(
                            labelText: "Answer",
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(5.0))),
                      ))));
        },
      ),
    ),
    ],
    ),
    ));
  }

  //TODO: Fetch the list from API

  Future fetchRequestedAssistance(String searchKey) {
    Future<Response> res;
    setState(() {
      res = dio.get('/assistance-request', queryParameters: {
        "page": 1,
        "limit": 25,
        "categoryId": selectedCategory,
        "key": searchKey,
        "startDate": _startDate,
        "endDate": _endDate
      });
    });
//    res.then((response) {
//      print(response);
//      if (response.statusCode == 200) {
//        for (int i = 0; i < response.data.length; i++) {
//          var singleRequest = AssistanceRequest.fromMapObject(response.data[i]);
//          fetchedList.add(singleRequest);
//        }
//      }
//    }).catchError((error) => {
//    Toast.show("somethingWentWrongTryAgain".tr(), context, duration: 3)
//    });
    return res;
  }

  //TODO change the request status based on input
  void showStatusOption() {
    List<String> actionList = ['Active', 'Closed'];
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ChangeStatusSheet(actionList);
        });
  }

  void getCategory() {
    Future<List<Category>> categoryListFuture = category.getCategoryList();
    categoryListFuture.then((categoryList) {
      setState(() {
        this.categoryList = categoryList;
      });
    });
  }

  void showFilterDialog() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (context) => Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Stack(
          children: [
            Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                            label: Text(
                          'filters',
                          style: AppTheme.title,
                        ).tr()),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context)),
                    ),
                  ],
                ),
//                    Container(
//                      child: Text(
//                        "category",
//                        style: AppTheme.title,
//                      ).tr(),
//                    ),
                Container(
                  child: DropdownButtonFormField(
                    hint: Text("category", style: AppTheme.textLabelSm).tr(),
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
                        selectedCategory = val;
                      });
                    },
                    value: selectedCategory,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: new MaterialButton(
                          color: AppTheme.accentColor,
                          onPressed: () => displayDateRangePicker(context),
                          child: new Text("dateRange").tr()),
                    ),
                  ],
                ),
                isDateSelected ? buildChips() : Container(),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton.icon(
                            color: AppTheme.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () => Navigator.of(context).pop(false),
                            icon: Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Colors.green,
                            ),
                            label: Text("apply".tr(),
                                style: TextStyle(color: Colors.black))),
                        OutlineButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                              setState(() {
                                selectedCategory = null;
                                _startDate = null;
                                _endDate = null;
                              });
                            },
                            icon: Icon(
                              CupertinoIcons.clear_thick_circled,
                              color: Theme.of(context).errorColor,
                            ),
                            label: Text(
                              "clear".tr(),
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChips() {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0,
      children: <Widget>[
        _startDate != null
            ? Chip(
                avatar: CircleAvatar(
                    backgroundColor: AppTheme.accentColor,
                    child: Text('ST').tr()),
                label: Text(
                    DateFormat('yyyy-MM-dd').format(_startDate).toString()),
              )
            : Container(),
        _endDate != null
            ? Chip(
                avatar: CircleAvatar(
                    backgroundColor: AppTheme.accentColor,
                    child: Text('EN').tr()),
                label:
                    Text(DateFormat('yyyy-MM-dd').format(_endDate).toString()),
              )
            : Container(),
      ],
    );
  }

  Future displayDateRangePicker(BuildContext context) async {
    picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: DateTime.now().subtract(Duration(days: 7)),
        initialLastDate: DateTime.now(),
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));

    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
        isDateSelected = true;
        print(_startDate);
      });
    }
  }
}
