import 'package:flutter/cupertino.dart';

class FieldModel {
  String name = "";
  bool req = false;
  String title = "";
  String type = "";

  static List listReq = ["Yes", "No"];
  static List listType = ["Text", "Number", "Date"];
  static String currentReq = "Yes";
  static String currentType = "Text";

  bool emptyAnswer = false;

  var answer = TextEditingController();
}
