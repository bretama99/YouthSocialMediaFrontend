import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youth_and_adolesence/Utils/app_theme.dart';

class ChangeStatusSheet extends StatefulWidget {
  final List<String> status;

  ChangeStatusSheet(this.status);

  @override
  _ChangeStatusSheetState createState() => _ChangeStatusSheetState();
}

class _ChangeStatusSheetState extends State<ChangeStatusSheet> {
  String selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: <Widget>[
          Chip(
              label: Text(
            'changeRequestStatus',
            style: AppTheme.title,
          ).tr()),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.status.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: widget.status[index],
                  groupValue: selectedStatus,
                  onChanged: (val) {
                    setState(() {
                      selectedStatus = val;
                    });
                  },
                  title: Text(widget.status[index]),
                );
              }),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlineButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      FontAwesomeIcons.save,
                      color: AppTheme.success,
                    ),
                    label: Text('save')),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: OutlineButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppTheme.danger,
                    ),
                    label: Text('cancel')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
