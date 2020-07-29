import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify/providers/note.dart';
import 'package:notify/providers/notebook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notebooks extends ChangeNotifier {
  List<Notebook> _list = [
//    Notebook(
//      id: '1',
//      title: 'Science and Technology',
//      labelId: '1',
//    ),
//    Notebook(
//      id: '2',
//      title: 'Mathematics',
//      labelId: '9',
//    ),
//    Notebook(
//      id: '3',
//      title: 'Language',
//      labelId: '4',
//    ),
  ];

  List<Notebook> get list => [..._list];

  Future<void> addNotebook(Notebook notebook) async{
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      Map<String, dynamic> data = {
        'title': notebook.title,
        'labelID': notebook.labelId,
      };
     final value =  await firestoreInstance
          .collection('notebooks')
          .document(user.uid)
          .collection('user_notebooks')
          .add(data);
      if(value != null){
        final retrievedNotebook = Notebook(
          id: value.documentID,
          title: notebook.title,
          labelId: notebook.labelId,
        );
        _list.add(retrievedNotebook);
        print('notebook id: ${retrievedNotebook.id}');
        notifyListeners();
      }

    } catch (error) {
      throw error;
    }
  }
  Future<void> deleteNotebook(id) async{
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {

      await firestoreInstance.collection('notebooks').document(user.uid).collection('user_notebooks').document(id).delete().then((value) {
        _list.removeWhere((notebook) => notebook.id == id);
        notifyListeners();
      });
    }catch(error){
      throw error;
    }


  }

  Notebook findById(String id) {

        return _list.firstWhere((notebook) => notebook.id == id, orElse: () => null);
  }

  Future<void> updateNotebook(Notebook  notebook) async{
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      Map<String, dynamic> data = {
        'title': notebook.title,
        'labelID': notebook.labelId,
      };
      await firestoreInstance.collection('notebooks').document(user.uid).collection('user_notebooks').document(notebook.id).updateData(data).then((_) {
        final index = _list.indexWhere((nBook) => notebook.id == nBook.id);
        _list[index] = notebook;
        notifyListeners();
      });
    }catch(error){
      throw error;
    }

  }

  Future<void> fetchNotebooks() async{
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try{
      var res = await firestoreInstance.collection('notebooks').document(user.uid).collection('user_notebooks').getDocuments();
      if(res.documents.isNotEmpty){
        _list.clear();
        res.documents.forEach((document) {
          Notebook notebook = Notebook(
            id:document.documentID,
            labelId: document['labelID']??'1',
            title: document['title'],
          );
          _list.add(notebook);
        });
      }
    } catch(error){
      throw error;
    }
  }

}
