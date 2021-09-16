import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/notes_model.dart';

class Add_new_note extends StatefulWidget {
  const Add_new_note({Key key,this.userid,this.noteID}) : super(key: key);
  final String userid;
  final String noteID;



  @override
  _Add_new_noteState createState() => _Add_new_noteState();
}



class _Add_new_noteState extends State<Add_new_note> {
  final _titleNote = TextEditingController();
  final _bodyNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Add New Note"),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _titleNote,
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
                    controller: _bodyNote,
                    maxLines: 20,
                    decoration: InputDecoration(
                        fillColor: Colors.grey,
                        focusColor: Colors.grey,
                        hintText: "write your Note here",
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
                      icon: Icon(Icons.done_rounded),
                      label: Text("Create"),
                      onPressed: () {

                        final notesRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userid)
                            .collection("notesInfo");
                        NotesModel noteModel = new NotesModel( userId: widget.userid,name: user.displayName, noteId: widget.noteID,noteTitle:_titleNote.text,noteBody:_bodyNote.text);
                        Map<String, dynamic> noteData = noteModel.toJson();
                         notesRef.doc(widget.noteID).set(noteData);



                        print("widget.noteid="+widget.noteID);
                        Navigator.of(context).pop();
                      },

                    )
                ),
              ],
            ),
          ),
        ));
  }
}
