import 'dart:convert';

import 'package:acme_app/configuration.dart';
import 'package:acme_app/models/userModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var database = FirebaseDatabase.instance.ref();
  UserModel user = UserModel();

  AppBar _appBar() {
    return AppBar(
      backgroundColor: ComponentColor,
    );
  }

  TextField fieldUsername() {
    return TextField(
      controller: user.username,
      decoration: InputDecoration(
        hintText: "username",
        hintStyle: TextStyle(
          color: ComponentColor.withOpacity(0.5)
        ),
        errorText: user.usernameReq? "username required": null,
      ),
    );
  }

  TextField fieldPassword() {
    return TextField(
      controller: user.password,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "password",
        hintStyle: TextStyle(
          color: ComponentColor.withOpacity(0.5)
        ),
        errorText: user.passwordReq? "password required": null
      ),
    );
  }

  TextButton btnLogin(BuildContext context, Size size) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: TextColor,
        backgroundColor: ComponentColor
      ),
      onPressed: () async {

        setState(() {
          if (user.username.text.isEmpty) {
            user.usernameReq = true;
          } else {
            user.usernameReq = false;
          }
          if (user.password.text.isEmpty) {
            user.passwordReq = true;
          } else {
            user.passwordReq = false;
          }
        });
            
        if (!user.usernameReq && !user.passwordReq) {
          var item = await database
            .child("users/${user.username.text}")
            .once();

          if (item.snapshot.value != null) {
            var myuser = item.snapshot.value as Map;
            if (myuser["password"] != user.password.text) {
              
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  content: Text("Password incorrect")
                )
              );

              return;
            }

            setState(() {
              user.username.text = "";
              user.password.text = "";
            });

            Navigator.pushNamed(context, "/list-quiz");

          } else {

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text("Username '${user.username.text}' doesn't exist"),
              )
            );

          }
        }
      },
      child: const Text("Login")
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 140,
              child: Image.asset("assets/icons/encuesta.png")
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: fieldUsername()
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: fieldPassword()
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 200,
              child: btnLogin(context, size)
            )
          ],
        )
      ),
    );
  }
}
