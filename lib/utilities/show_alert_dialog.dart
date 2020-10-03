import 'package:flutter/material.dart';

Future<void> showAlertDialog({
  BuildContext context,
  String title,
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
