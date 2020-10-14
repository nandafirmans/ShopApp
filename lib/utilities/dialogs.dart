import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showAlertDialog({
    BuildContext context,
    String title = 'Error Occurred',
    String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  static Future<void> showLoadingDialog({BuildContext context, GlobalKey key}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
          key: key,
          children: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
