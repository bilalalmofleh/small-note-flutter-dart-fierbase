import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Edit_note extends StatefulWidget {
  const Edit_note({Key key}) : super(key: key);

  @override
  _Edit_noteState createState() => _Edit_noteState();
}

class _Edit_noteState extends State<Edit_note> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Edit Note"),
      ),
      body:SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  maxLength: 30,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      focusColor: Colors.grey,
                      hintText: "Title note",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  maxLines: 20,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      focusColor: Colors.grey,
                      hintText: "Title note",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text("Save Edit"),
                  onPressed: (){},
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}
