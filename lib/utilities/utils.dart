import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {

  static Utils _utils;
  Utils._createInstance();

  factory Utils() {
    if (_utils == null) {
      _utils = Utils._createInstance();
    }
    return _utils;
  }

  void showAlertDialog(
      BuildContext context, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  void showSnackBar(var scaffoldkey, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1, milliseconds: 500),
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  Future<String> selectDate(BuildContext context, String date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: date.isEmpty
            ? DateTime.now()
            : new DateFormat("d MMM, y").parse(date),
        lastDate: DateTime(2022));
        if (picked != null)
          return formatDate(picked);

    return "";
  }

  String formatDate(DateTime selectedDate) =>
      new DateFormat("d MMM, y").format(selectedDate);
}
