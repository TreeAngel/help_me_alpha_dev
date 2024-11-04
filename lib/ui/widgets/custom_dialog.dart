import 'package:flutter/material.dart';

class CustomDialog {
  static showAlertDialog(
    BuildContext context,
    String title,
    String? content,
    Widget? action,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: [
          if (action != null) action,
        ],
      ),
    );
  }
}
