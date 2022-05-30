import 'package:acme_app/configuration.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FieldClass {
  String name;
  String title;
  bool req;
  String type;

  FieldClass(this.name, this.title, this.req, this.type);
}

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuizScreen> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuizScreen> {
  var database = FirebaseDatabase.instance.ref();
  String reqValue = "Yes";
  String fieldValue = "Text";

  List<String> reqItem = ["Yes", "No"];
  List<String> fieldItem = ["Text", "Number", "Date"];
  List<FieldClass> field = [];

  var titleQuizController = TextEditingController();
  var desQuizController = TextEditingController();
  var nameFieldController = TextEditingController();
  var titleFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //nameFieldController.text = "";
    //titleFieldController.text = "";
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Create Quiz"),
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
                  field.add(
                    FieldClass(
                      nameFieldController.text, 
                      titleFieldController.text,
                      reqValue == "Yes"? true: false,
                      fieldValue
                    )
                  );
                });
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
      onPressed: () async {
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
        
        if (item.snapshot.value == null) {
          var uId = Uuid().v1().toString();
          print(uId);
          database
            .child("quizes/${titleQuizController.text}")
            .set({
              "title": titleQuizController.text,
              "description": desQuizController.text,
              "uId": uId,
              "field": field.map((e) => {
                "name": e.name,
                "title": e.title,
                "req": e.req,
                "type": e.type
              }).toList()
            });
          Navigator.pop(context);
        } else {
          print("Quiz '${titleQuizController.text}' already exists");
        }
      },
      backgroundColor: ComponentColor,
      child: const Icon(Icons.save)
    );
  }

  Widget listField(Size size) {
    return SizedBox(
      height: size.height * 0.25,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: field.length,
        itemBuilder: (context, position) {

          var widget = field[position].type == "Text"?
                        const Icon(Icons.text_fields) :
                        field[position].type == "Number"?
                        const Icon(Icons.numbers) :
                        const Icon(Icons.date_range) ;

          return Card(
            child: ListTile(
              title: Text(field[position].name),
              subtitle: Text("Title: ${field[position].title}"),
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
                          field.removeAt(position);
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