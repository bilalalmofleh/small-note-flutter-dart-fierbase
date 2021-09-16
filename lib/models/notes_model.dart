import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  final String noteId;
  final String name;
  final String userId;
  final String noteTitle;
  final String noteBody;

  NotesModel(
      {this.noteId,
        this.name,
        this.userId,
        this.noteTitle,
        this.noteBody,
        });

  Map<String, dynamic> toJson() => {
    'noteId': noteId,
    'name': name,
    'userId': userId,
    'noteTitle': noteTitle,
    'noteBody': noteBody,

  };

  NotesModel.fromJson(Map<String, dynamic> json)
      : noteId = json['noteId'],
        name = json['name'],
        userId = json['userId'],
        noteTitle = json['noteTitle'],
        noteBody = json['noteBody']
       ;

  factory NotesModel.fromDoc(DocumentSnapshot doc) {
    return NotesModel(
        noteId: doc.id,
        name: doc['name'],
        userId: doc['userId'],
        noteTitle: doc['noteTitle'],
        noteBody: doc['noteBody']
        );
  }
}


