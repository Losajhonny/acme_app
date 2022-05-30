
import 'package:acme_app/configuration.dart';
import 'package:acme_app/models/answerModel.dart';
import 'package:acme_app/models/fieldModel.dart';
import 'package:acme_app/models/quizModel.dart';
import 'package:acme_app/screens/quiz/arguments.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowAnswerScreen extends StatefulWidget {
  const ShowAnswerScreen({Key? key}) : super(key: key);

  @override
  State<ShowAnswerScreen> createState() => _ShowAnswerScreenState();
}

class _ShowAnswerScreenState extends State<ShowAnswerScreen> {
  var database = FirebaseDatabase.instance.ref();
  var onetime = true;
  List<AnswerModel> answers = [];
  QuizModel quiz = QuizModel();

  @override
  void initState() {
    super.initState();
  }

  downloadQuiz(String uid) async {
    if (!onetime) {
      return;
    } else {
      setState(() {
        onetime = false;
      });
    }

    try {

      List<DataSnapshot> answerData = 
        (await database.child("answers").child(uid).once())
          .snapshot
          .children
          .toList()
          ;

      var infoquiz = answerData.first.value as Map;
      
      setState(() {
        quiz.title = infoquiz["quiz"];
        quiz.uId = infoquiz["uId"];

        for (var item in answerData) {
          var answer = AnswerModel();
          answer.quiz = quiz.title;
          answer.uId = quiz.uId;

          var lista = item.child("answers").value as List;

          for (var element in lista) {
            var ans = element as Map;
            answer.answers.add({
              "title": ans["title"],
              "answer": ans["answer"]
            });
          }
          answers.add(answer);
        }
      });

    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content:  Text("There aren't answers"), 
        )
      );
    }
  }

  Widget listAllAnswer() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      itemCount: answers.length,
      itemBuilder: (context, position) {
        var answer = answers[position];

        return Card(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text("Answer No. ${position + 1}"),
              ),
              listAnswer(answer)
            ],
          )
        );
      },
    );
  }

  Widget listAnswer(AnswerModel answer) {

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: answer.answers.length,
              itemBuilder: (context, position) {
                var ans = answer.answers[position] as Map;

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.question_answer),
                    title: Text(ans["title"]),
                    subtitle: Text(ans["answer"]),
                  ),
                );
              }
            )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Argument args = ModalRoute.of(context)!.settings.arguments as Argument;
    downloadQuiz(args.uid);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(quiz.title),
        backgroundColor: ComponentColor,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.quiz),
                title: Text(quiz.uId),
              ),
            ),
            Expanded(child: listAllAnswer())
          ],
        ),
      )
    );
  }
}
