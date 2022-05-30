
import 'package:acme_app/configuration.dart';
import 'package:acme_app/models/answerModel.dart';
import 'package:acme_app/screens/quiz/arguments.dart';
import 'package:acme_app/models/fieldModel.dart';
import 'package:acme_app/models/quizModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnswerScreen extends StatefulWidget {

  const AnswerScreen({Key? key}) : super(key: key);

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  var database = FirebaseDatabase.instance.ref();
  QuizModel quiz = QuizModel();
  var onetime = true;

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

    List<DataSnapshot> quizes =
      (
        await database
          .child("quizes")
          .once()
      )
        .snapshot
        .children
        .toList();

    try{
      var myquiz = 
        (
          quizes
            .where(
              (element) {
                return (element.value as Map)["uId"] == uid;
              }
            )
            .first
            .value
        ) as Map;

      setState(() {
        quiz = QuizModel();
        quiz.title = myquiz["title"];
        quiz.description = myquiz["description"];
        quiz.uId = myquiz["uId"];
        
        try {
          for (var e in myquiz["field"] as List) {
            var item = e as Map;
            var field = FieldModel();
            field.name = item["name"];
            field.req = item["req"];
            field.title = item["title"];
            field.type = item["type"];
            quiz.fields.add(field);
          }
        // ignore: empty_catches
        } catch(e) {  }
      });

    } catch(e) {
      print("element not found for uId: ${uid}");
    }
  }

  Widget listField() {
    //print(fields.length);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: quiz.fields.length,
      itemBuilder: (context, position) {
        var field = quiz.fields[position] as FieldModel;
        
        if (field.type.toLowerCase() == "number") {
            return TextField(
              controller: field.answer,
              decoration: InputDecoration(
                icon: const Icon(Icons.numbers),
                labelText: "Enter ${field.title}",
                errorText: field.emptyAnswer? "required": null,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
            );
        }
        else if (field.type.toLowerCase() == "date") {
          return TextField(
            controller: field.answer,
            decoration: InputDecoration(
              icon: const Icon(Icons.calendar_today),
              labelText: "Enter ${field.title}",
              errorText: field.emptyAnswer? "required": null,
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                setState(() {
                  (quiz.fields[position] as FieldModel).answer.text = "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                });
              }
            },
          );
        }
        else {
          return TextField(
            controller: field.answer,
            decoration: InputDecoration(
              icon: const Icon(Icons.text_fields),
              labelText: "Enter ${field.title}",
              errorText: field.emptyAnswer? "required": null,
            ),
          );
        }
      },
    );
  }

  void saveAnswer() {
    setState(() {
      for (var item in quiz.fields) {
        var field = item as FieldModel;
        if (field.answer.text.isEmpty) {
          field.emptyAnswer = field.req;
        } else {
          field.emptyAnswer = false;
        }
      }
    });

    var answer = AnswerModel();
    answer.quiz = quiz.title;
    answer.uId = quiz.uId;
    for (var item in quiz.fields) {
      var field = item as FieldModel;
      answer.answers.add({"title": field.title, "answer": field.answer.text});
    }
    
    database
      .child("answers")
      .child("/${answer.uId}")
      .push()
      .set(answer.toObject());
    
    Navigator.pop(context);
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
                subtitle: Text(quiz.description),
              ),
            ),
            Expanded(child: listField()),
            IconButton(
              onPressed: saveAnswer,
              icon: const Icon(Icons.save),
              tooltip: "save answer",
              color: ComponentColor,
            ),
          ],
        ),
      )
    );
  }
}
