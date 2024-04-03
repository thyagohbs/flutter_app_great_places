import 'package:flutter/material.dart';

class SnackCustom {
  static void snack(
      {required BuildContext context,
      required String message,
      int secondsDuration = 3}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: secondsDuration),
      ),
    );
  }
}
