import 'package:flutter/material.dart';

class AppSnackBar {
  static void showSnackBar(ScaffoldState? scaffoldState, String? result) {
    if (result == null || result.isEmpty) return;
    scaffoldState!.showSnackBar(
        SnackBar(content: Text(result), duration: Duration(seconds: 3)));
  }
}