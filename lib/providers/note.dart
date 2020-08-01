import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note extends ChangeNotifier {
  final String id;
   String title;
   List<String> tags;
   String body;
   String notebookId;
   DateTime timestamp;
   bool bookmark;

  Note(
      {@required this.id,
      @required this.title,
       this.tags,
      @required this.notebookId,
      @required this.timestamp,
       @required this.body,
      this.bookmark = false}){
   if(tags == null){
     tags = List<String>();
   }
  }

  Future<void> toggleBookmark() async{
    print('toggle called');
    this.bookmark = !this.bookmark;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      Map<String, dynamic> data = {
        'bookmark': this.bookmark,
      };
      await firestoreInstance.collection('notes').document(user.uid).collection('user_notes').document(this.id).updateData(data).then((_) {

      });
    }catch(error){
      this.bookmark = !this.bookmark;
      notifyListeners();
      throw error;
    }


  }

  Future<void> updateContent(String content) async{
    final date = DateTime.now();
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      Map<String, dynamic> data = {
        'body': content,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await firestoreInstance.collection('notes').document(user.uid).collection('user_notes').document(this.id).updateData(data).then((_) {
        this.body = content;
        this.timestamp = date;
        notifyListeners();
      });
    }catch(error){
      throw error;
    }

  }
  Future<void> updateDetails(List<String> tags, String title, String notebookId) async{

    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      Map<String, dynamic> data = {
        'tags': List.from(tags),
        'title': title,
        'notebookID': notebookId,
      };
      await firestoreInstance.collection('notes').document(user.uid).collection('user_notes').document(this.id).updateData(data).then((_) {
        this.tags =tags;
        this.title = title;
        this.notebookId = notebookId;
        notifyListeners();
      });
    }catch(error){
      throw error;
    }



  }
}

