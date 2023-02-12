import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HealthProfessionalList extends StatefulWidget {
  @override
  _HealthProfessionalListState createState() => _HealthProfessionalListState();
}

class _HealthProfessionalListState extends State<HealthProfessionalList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('healthProfessionals').tr(),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add_circle), onPressed: () {})
        ],
      ),
    );
  }
}
