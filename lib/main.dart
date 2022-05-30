import 'package:acme_app/firebase_options.dart';
import 'package:acme_app/screens/auth/login.dart';
import 'package:acme_app/screens/auth/register.dart';
import 'package:acme_app/screens/quiz/answerQuiz.dart';
import 'package:acme_app/screens/quiz/createQuiz.dart';
import 'package:acme_app/screens/quiz/editQuiz.dart';
import 'package:acme_app/screens/quiz/listQuiz.dart';
import 'package:acme_app/screens/quiz/showAnswer.dart';
import 'package:acme_app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      title: 'Acme Project',
      initialRoute: "/",
      routes: {
        "/": (context) => const WelcomeScreen(),
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen(),
        "/list-quiz": (context) => const ListQuizScreen(),
        "/answer-quiz": (context) => const AnswerScreen(),
        "/create-quiz": (context) => const CreateQuizScreen(),
        "/edit-quiz": (context) => const EditQuizScreen(),
        "/show-answer": (context) => const ShowAnswerScreen(),
      },
    );
  }
}
