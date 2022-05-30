import 'package:acme_app/configuration.dart';
import 'package:acme_app/models/userModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  TextButton btnRegister(Size size) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: TextColor,
        backgroundColor: ComponentColor
      ),
      onPressed: clickRegister,
      child: const Text("Register")
    );
  }

  void clickRegister() async {
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
      var key = user.username.text;
      var myuser = await database
        .child("users/$key")
        .once();

      if (myuser.snapshot.value != null) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text("User already exists"),
          )
        );
        return;
      }
        
      database
        .child("users")
        .child("/$key")
        .set(user.toObject());

      setState(() {
        user.username.text = "";
        user.password.text = "";
      });

      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("User has been created"),
        )
      );
      
    } else {

      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("There are fields required"), 
        )
      );

    }
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
              child: btnRegister(size)
            )
          ],
        )
      ),
    );
  }
}
