import 'package:acme_app/configuration.dart';
import 'package:acme_app/models/fieldModel.dart';
import 'package:acme_app/models/quizModel.dart';
import 'package:acme_app/screens/quiz/arguments.dart';
import 'package:acme_app/screens/quiz/createQuiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EditQuizScreen extends StatefulWidget {
  const EditQuizScreen({Key? key}) : super(key: key);

  @override
  State<EditQuizScreen> createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuizScreen> {
  var database = FirebaseDatabase.instance.ref();
  String reqValue = "Yes";
  String fieldValue = "Text";

  List<String> reqItem = ["Yes", "No"];
  List<String> fieldItem = ["Text", "Number", "Date"];
  List<FieldModel> field = [];

  var titleQuizController = TextEditingController();
  var desQuizController = TextEditingController();
  var nameFieldController = TextEditingController();
  var titleFieldController = TextEditingController();

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

        titleQuizController.text = quiz.title;
        desQuizController.text = quiz.description;
        
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
          field = quiz.fields as List<FieldModel>;
        // ignore: empty_catches
        } catch(e) {  }
      });

    } catch(e) {
      print("element not found for uId: ${uid}");
    }
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Edit Quiz"),
      backgroundColor: ComponentColor,
    );
  }

  TextField title() {
    return TextField(
      controller: titleQuizController,
      decoration: InputDecoration(
        hintText: "Title",
        hintStyle: TextStyle(
          color: ComponentColor.withOpacity(0.5)
        ),
      ),
    );
  }

  TextField description() {
    return TextField(
      controller: desQuizController,
      decoration: InputDecoration(
        hintText: "Description",
        hintStyle: TextStyle(
          color: ComponentColor.withOpacity(0.5)
        ),
      ),
    );
  }

  TextField nameField() {
    return TextField(
      controller: nameFieldController,
      decoration: InputDecoration(
        hintText: "Name",
        hintStyle: TextStyle(
          color: ComponentColor.withOpacity(0.5)
        ),
      ),
    );
  }

  TextField titleField() {
    return TextField(
      controller: titleFieldController,
      decoration: InputDecoration(
        hintText: "Title",
        hintStyle: TextStyle(
          color: ComponentColor.withOpacity(0.5)
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item)
    );
  }

  DropdownButton<String> dropDownRequired() {
    return DropdownButton<String>(
      style: const TextStyle(color: ComponentColor),
      value: reqValue,
      onChanged: (newValue) {
        setState(() {
          reqValue = newValue.toString();
          print(reqValue);
        });
      },
      items: reqItem.map(buildItem).toList(),
    );
  }

  DropdownButton<String> dropDownType() {
    return DropdownButton<String>(
      value: fieldValue,
      style: const TextStyle(color: ComponentColor),
      onChanged: (newValue) {
        setState(() {
          fieldValue = newValue.toString();
          print(fieldValue);
        });
      },
      items: fieldItem.map(buildItem).toList(),
    );
  }

  IconButton btnAddField(context, size) {
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Field",
            style: TextStyle(
              color: ComponentColor,
            ),
          ),
          content: Column(
            children: [
              SizedBox(width: size.width * 0.6, child: nameField()),
              SizedBox(height: 3),
              SizedBox(width: size.width * 0.6, child: titleField()),
              SizedBox(height: 5),
              SizedBox(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Required",
                      style: TextStyle(
                        color: ComponentColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.2,
                      child: dropDownRequired(),
                    ),
                  ],
                )
              ),
              SizedBox(height: 5),
              SizedBox(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Type Field",
                      style: TextStyle(
                        color: ComponentColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.2,
                      child: dropDownType(),
                    ),
                  ],
                )
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "Cancel"),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameFieldController.text.isEmpty) {
                  print("Name empty");
                  return;
                }
                if (titleFieldController.text.isEmpty) {
                  print("Title empty");
                  return;
                }
                setState(() {
                  var myfield = FieldModel();
                  myfield.name = nameFieldController.text;
                  myfield.title = titleFieldController.text;
                  myfield.req = reqValue == "Yes"? true: false;
                  myfield.type = fieldValue;
                  quiz.fields.add(myfield);
                });
                // update
                Navigator.pop(context, "Add");
              },
              child: const Text('Add'),
            ),
          ],
        )
      ),
      //backgroundColor: ComponentColor,
      //child: const Icon(Icons.add),
      icon: Icon(Icons.add),
    );
  }

  FloatingActionButton btnSaveQuiz() {
    return FloatingActionButton(
      onPressed: btnSave,
      backgroundColor: ComponentColor,
      child: const Icon(Icons.save)
    );
  }

  btnSave() async {
    if (titleQuizController.text.isEmpty) {
      print("Title quiz is empty");
      return;
    }
    if (desQuizController.text.isEmpty) {
      print("Description quiz is empty");
      return;
    }
    var item = await database
      .child("quizes/${titleQuizController.text}")
      .once();
    
    if (item.snapshot.value != null) {
      database
        .child("quizes/${titleQuizController.text}")
        .set({
          "title": titleQuizController.text,
          "description": desQuizController.text,
          "uId": quiz.uId,
          "field": quiz.fields.map((e) => {
            "name": e.name,
            "title": e.title,
            "req": e.req,
            "type": e.type
          }).toList()
        });
      Navigator.pop(context);
    } else {
      print("Quiz '${titleQuizController.text}' don't updated");
    }
  }

  Widget listField(Size size) {
    return SizedBox(
      height: size.height * 0.25,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: quiz.fields.length,
        itemBuilder: (context, position) {

          var widget = quiz.fields[position].type == "Text"?
                        const Icon(Icons.text_fields) :
                        quiz.fields[position].type == "Number"?
                        const Icon(Icons.numbers) :
                        const Icon(Icons.date_range) ;

          return Card(
            child: ListTile(
              title: Text(quiz.fields[position].name),
              subtitle: Text("Title: ${quiz.fields[position].title}"),
              leading:  widget,
              trailing: SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      tooltip: "Delete",
                      icon: const Icon(Icons.delete),
                      onPressed: () => { 
                        setState(() {
                          quiz.fields.removeAt(position);
                        })
                      }
                    ),
                  ],
                ),
              ),
            )
          );
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Argument args = ModalRoute.of(context)!.settings.arguments as Argument;
    downloadQuiz(args.uid);
    
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: SizedBox(
          width: size.width * 0.9,
          child: Card(
            child: Column(
              children: [
                SizedBox(width: size.width * 0.8, child: title()),
                SizedBox(width: size.width * 0.8, child: description()),
                SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [btnAddField(context, size)],
                  ),
                ),
                Expanded(
                  child: listField(size)
                ),
              ],
            ),
          ),
        )
      ),
      floatingActionButton: btnSaveQuiz()
    );
  }
}