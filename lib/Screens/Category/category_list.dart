import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:youth_and_adolesence/Models/category.dart';
import 'package:youth_and_adolesence/Screens/Category/add_category.dart';
import 'package:youth_and_adolesence/Screens/Category/update_category.dart';
import 'package:youth_and_adolesence/Utils/app_config.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  var _refreshIndicator = GlobalKey<RefreshIndicatorState>();
  Future<List<Category>> list;
  Category category = Category.empty();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryCache();
//    fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('category').tr(),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_circle), onPressed: () => addCategory())
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicator,
        onRefresh: fetchCategory,
        child: FutureBuilder<List<Category>>(
            future: list,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.error,
                          size: 50,
                        ),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ));
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.objectGroup,
                                color: AppTheme.nearlyBlack,
                              ),
                              title: Text(snapshot.data[index].categoryName),
//                              subtitle: Text(snapshot.data[index].createdAt),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppTheme.danger,
                                  ),
                                  onPressed: () => deleteCategory(
                                      snapshot.data[index].categoryId)),
                              onTap: () => updateCategory(snapshot.data[index]),
                            ),
                          );
                        });
                  break;
                default:
                  return Center(
                      child: Container(
                    child: Text('somethingWentWrongTryAgain').tr(),
                  ));
              }
            }),
      ),
    );
  }

  void addCategory() {
    showDialog(
        context: context,
        builder: (context) {
          return AddCategory();
        }).then((value) => value ? fetchCategory() : null);
  }

  void updateCategory(Category category) {
    showDialog(
        context: context,
        builder: (context) {
          return UpdateCategory(category);
        }).then((value) => value ? fetchCategory() : null);
  }

  Future<List<Category>> getCategoryCache() async {
//    Category category = Category("HIV", "i2NOVG0EFEMgjX67MmmgsoaOSIFahj", DateTime.now().toIso8601String());
//    category.insertCategory(category);
    setState(() {
      list = category.getCategoryList();
    });
    return list;
  }

  Future fetchCategory() {
    Future<Response> res = dio.get('/category');
    res.then((response) async {
      List<Category> fetchedList = [];
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          var singleCategory = Category.fromMapObject(response.data[i]);
          fetchedList.add(singleCategory);
          //update or insert
          Category cached =
              await category.getSingleCategory(singleCategory.categoryId);
          if (cached != null) {
            category.updateCategory(singleCategory);
          } else {
            category.insertCategory(singleCategory);
          }
        }

        //remove deleted tuples
        category.removeDeletedRows(fetchedList);
        Toast.show("updated".tr(), context);
      }

      return getCategoryCache();
    }).catchError((error) {
      Toast.show("somethingWentWrongTryAgain".tr(), context, duration: 3);
    });

    return res;
  }

  deleteCategory(int id) {
    //TODO show dialog return value utilize it after deletion and insertion for all
    showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("deleteCategoryWarning").tr(),
            title: Text("deleteWarning").tr(),
            actions: <Widget>[
              OutlineButton.icon(
                label: Text("yes").tr(),
                onPressed: () {
                  dio.delete('/category/$id').then((res) {
                    if (res.statusCode == 200) {
                      print(res.data);
                      if (res.data == '1') {
                        Toast.show("deletionSuccessful".tr(), context,
                            backgroundColor: AppTheme.success, duration: 3);
                        Navigator.pop(context, true);
                        fetchCategory();
                      }
                    }
                  }).catchError((error) => {
                        Toast.show("somethingWentWrongTryAgain".tr(), context,
                            backgroundColor: AppTheme.danger, duration: 3)
                      });
                },
                icon: Icon(Icons.check_circle, color: AppTheme.danger),
              ),
              OutlineButton.icon(
                label: Text(
                  "no",
                  style: TextStyle(color: AppTheme.success),
                ).tr(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: AppTheme.success,
                ),
              ),
            ],
          );
        });
  }
}
