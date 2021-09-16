import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/notes_model.dart';

class View_note extends StatefulWidget {
  const View_note({Key key ,this.noteid_,this.userid}) : super(key: key);
  final String noteid_;
  final String userid;



  @override
  _View_noteState createState() => _View_noteState();

}

class _View_noteState extends State<View_note> {

  bool edit=false;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("View Note"),
          actions: [
            Center(
              child: InkWell(
                  onTap: () {
                    AlertDialog alert = AlertDialog(
                      title: Text('Delete ??'),
                      content: SingleChildScrollView(
                          child: ListBody(children: <Widget>[
                        Text('Are you sure you want to delete this note?'),
                      ])),
                      actions: [
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () {
                             FirebaseFirestore.instance.collection('users')
                                .doc(widget.userid)
                                .collection("notesInfo").doc(widget.noteid_).delete();

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "Delete",
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.delete_rounded),
                    ],
                  )),
            ),
          ],
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userid)
                .collection("notesInfo")
                .doc(widget.noteid_)
                .get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new CircularProgressIndicator(),
                    ],
                  ),
                ],
              );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new CircularProgressIndicator(),
                        ],
                      ),
                    ],
                  );
                default:
                  Map<String, dynamic> data = snapshot.data.data();
                  NotesModel notesModel = NotesModel.fromJson(data);
                  final _titleEditNote = TextEditingController(text: notesModel.noteTitle,);
                  final _bodyEditNote = TextEditingController(text: notesModel.noteBody,);
                  return SingleChildScrollView(
                    child: edit?  Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextField(
                              controller: _titleEditNote,
                              maxLength: 30,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  focusColor: Colors.grey,
                                  labelText: "Title note",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextField(
                              controller: _bodyEditNote,
                              maxLines: 20,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  focusColor: Colors.grey,
                                  hintText: "Title body",
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
                                onPressed: (){
                                  setState(() {
                                    final notesRef = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.userid)
                                        .collection("notesInfo");
                                    NotesModel noteModel = new NotesModel( userId: widget.userid,name: user.displayName, noteId: widget.noteid_,noteTitle:_titleEditNote.text,noteBody:_bodyEditNote.text);
                                    Map<String, dynamic> noteData = noteModel.toJson();
                                    notesRef.doc(widget.noteid_).set(noteData);
                                    edit=false;
                                    print("edit= $edit");


                                  });



                                },
                              )
                          ),
                        ],
                      )
                    : InkWell(
                      onTap: (){
                        setState(() {
                          edit=true;
                          print("edit= $edit");
                        });
                      },
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  notesModel.noteTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 30)
                                ),
                              ),

                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Text(
                                  notesModel.noteBody,
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  );
              }
            }));
  }
}
