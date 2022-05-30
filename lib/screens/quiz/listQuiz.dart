import 'dart:convert';

import 'package:acme_app/configuration.dart';
import 'package:acme_app/screens/quiz/arguments.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ListQuizScreen extends StatefulWidget {
  const ListQuizScreen({Key? key}) : super(key: key);

  @override
  State<ListQuizScreen> createState() => _ListQuizScreenState();
}

class _ListQuizScreenState extends State<ListQuizScreen> {
  var database = FirebaseDatabase.instance.ref();
  late DatabaseReference quizesRef;

  @override
  void initState() {
    super.initState();
    quizesRef = database.child("quizes");
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Quizes"),
      backgroundColor: ComponentColor,
    );
  }

  FloatingActionButton btnAddField(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(
          context, 
          "/create-quiz"
        );
      },
      backgroundColor: ComponentColor,
      child: const Icon(Icons.add),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: FirebaseAnimatedList(
        itemBuilder: (
          context,
          snapshot,
          animation,
          index
        ) {
          var value = Map.from(snapshot.value as Map);
          print(value["uId"]);
          return Card(
            margin: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(value["title"]),
              subtitle: Text(value["uId"]),
              trailing: SizedBox(
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      tooltip: "Show answer",
                      icon: const Icon(Icons.question_answer_outlined),
                      onPressed: () => { Navigator.pushNamed(context, "/show-answer", arguments: Argument(value["uId"])) }
                    ),
                    IconButton(
                      tooltip: "Answer quiz",
                      icon: const Icon(Icons.quiz),
                      onPressed: () => { Navigator.pushNamed(context, "/answer-quiz", arguments: Argument(value["uId"])) }
                    ),
                    IconButton(
                      tooltip: "Edit",
                      icon: const Icon(Icons.edit),
                      onPressed: () => { Navigator.pushNamed(context, "/edit-quiz", arguments: Argument(value["uId"])) }
                    ),
                    IconButton(
                      tooltip: "Delete",
                      icon: const Icon(Icons.delete),
                      onPressed: () => { quizesRef.child(snapshot.key!).remove() }
                    ),
                  ],
                )
              ),
            )
          );
        },
        shrinkWrap: true,
        query: quizesRef,
      ),
      floatingActionButton: btnAddField(context),
    );
  }
}
