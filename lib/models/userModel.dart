import 'package:flutter/cupertino.dart';

class UserModel {
  var username = TextEditingController();
  var password = TextEditingController();

  bool usernameReq = false;
  bool passwordReq = false;

  Object toObject() {
    return {
      "username": username.text,
      "password": password.text
    };
  }
}