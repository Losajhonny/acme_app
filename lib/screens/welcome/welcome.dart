
import 'package:acme_app/configuration.dart';
import 'package:acme_app/screens/quiz/arguments.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Body()),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var uid = TextEditingController();

  Text welcomeText() {
    return const Text(
      "Welcome to Acme Quiz",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
      )
    );
  }

  TextButton btnRegister(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: TextColor,
        backgroundColor: ComponentColor
      ),
      onPressed: () => {
        Navigator.pushNamed(context, "/register")
      },
      child: const Text("Register")
    );
  }

  TextButton btnLogin(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: TextColor,
        backgroundColor: ComponentColor
      ),
      onPressed: () => {
        Navigator.pushNamed(context, "/login")
      },
      child: const Text("Login")
    );
  }

  Column reqQuiz(Size size) {
    return Column(
      children: [
        SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: TextField(
            controller: uid,
            decoration: InputDecoration(
              hintText: "uid quiz",
              hintStyle: TextStyle(
                color: ComponentColor.withOpacity(0.5)
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: TextColor,
              backgroundColor: ComponentColor
            ),
            onPressed: () {
              if (uid.text.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  "/answer-quiz",
                  arguments: Argument(uid.text)
                );
              } else {

                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    content:  Text("uid is required"), 
                  )
                );

              }
              setState(() {
                uid.text = "";
              });
            },
            child: const Text("Quiz")
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        welcomeText(),
        SizedBox(height: 10),
        SizedBox(
          width: 140,
          child: Image.asset(
            "assets/icons/test.png",
          ),
        ),
        SizedBox(height: 20),
         SizedBox(
          width: 200,
          child: btnRegister(context)
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: btnLogin(context)
        ),
        SizedBox(height: 10),
        reqQuiz(size)
      ],
    );
  }
}
