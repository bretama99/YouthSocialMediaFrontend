import 'package:flutter/material.dart';

class Notifier extends StatelessWidget {
  final String message;
  final Color color;

  Notifier({this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
  }
}
