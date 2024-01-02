import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConstToast {
  static void success(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.teal,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static void error(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16,
    );
  }
}
