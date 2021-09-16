import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:small_note/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:small_note/view_note.dart';
import 'add_new_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/notes_model.dart';


class View_all_notes extends StatefulWidget {
  const View_all_notes({Key key}) : super(key: key);

  @override
  _View_all_notesState createState() => _View_all_notesState();
}

class _View_all_notesState extends State<View_all_notes> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    /////////////////////////////////////////////////////////////////////////
    var userDocId = user.email;
    print("*************************");
    print("userDocId= $userDocId");
    print("*************************");

    var _noteID = DateTime.now().microsecondsSinceEpoch;
    print("*************************");
    print("_noteID= $_noteID");
    print("*************************");

    final userRef = FirebaseFirestore.instance.collection('users');
    NotesModel noteModel = new NotesModel(
        userId: userDocId,
        name: user.displayName,
        );
    Map<String, dynamic> noteData = noteModel.toJson();
    userRef.doc(userDocId).set(noteData);
    /////////////////////////////////////////////////////////////////////////

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(user.displayName),
          actions: [
            IconButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                icon: Icon(FontAwesomeIcons.signOutAlt))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Add_new_note(userid: userDocId.toString(),noteID: _noteID.toString(),)),
            );
            _noteID++;
            print("_noteID after create new note= $_noteID");
          },
          child: const Icon(
            Icons.add_rounded,
            size: 35,
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 5,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userDocId.toString())
              .collection("notesInfo")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Row(
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
                return  Row(
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
                return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: snapshot.data.docs.map((document) {
                        return Container(
                          child: new Card(
                            margin: EdgeInsets.all(10),
                            color: Colors.amber[50],
                            elevation: 5,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => View_note(
                                          noteid_:
                                              document['noteId'].toString(),
                                          userid:
                                              document['userId'].toString())),
                                );

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin:
                                              EdgeInsets.fromLTRB(5, 5, 5, 0),
                                          child: Text(
                                            document['noteTitle'].length > 15
                                                ? '${document['noteTitle'].substring(0, 9)}...'
                                                : document['noteTitle'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin:
                                              EdgeInsets.fromLTRB(5, 10, 5, 5),
                                          child: Text(
                                            document['noteBody'].length > 60
                                                ? '${document['noteBody'].substring(0, 60)}.....'
                                                : document['noteBody'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ));
            }
          },
        ));
  }
}
