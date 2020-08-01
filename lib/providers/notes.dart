import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note.dart';

class Notes extends ChangeNotifier {
  bool initialFetch = false;
  List<Note> _list = [
//    Note(
//        id: '1a',
//        title: 'Newton\'s first law of motion',
//        tags: [
//          'Science',
//          'Physics',
//          'Motion',
//          'Newton',
//          'Laws of Motion',
//          'Lecture Notes'
//        ],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '1'),
//    Note(
//        id: '1b',
//        title: 'Newton\'s second law of motion',
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '1'),
//    Note(
//        id: '1c',
//        title: 'Newton\'s third law of motion',
//        tags: ['Science', 'Physics', 'Motion'],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '1'),
//    Note(
//        id: '2a',
//        title: 'Riemann\'s Integration part a',
//        tags: ['Science', 'Physics', 'Motion'],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '2'),
//    Note(
//        id: '2b',
//        title: 'Riemann\'s Integration part b',
//        tags: ['Science', 'Physics', 'Motion'],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '2'),
//    Note(
//        id: '2c',
//        title: 'Riemann\'s Integration part c',
//        tags: ['Science', 'Physics', 'Motion'],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '2'),
//    Note(
//        id: '3a',
//        title: 'Newton\'s first law of motion',
//        tags: ['Science', 'Physics', 'Motion'],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '3'),
//    Note(
//        id: '3b',
//        title: 'Newton\'s first law of motion',
//        tags: ['Science', 'Physics', 'Motion'],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '3'),
//    Note(
//        id: '3c',
//        title: 'Newton\'s first law of motion',
//        tags: ['Science', 'Physics', 'Motion'],
//        date: DateTime.now(),
//        content: 'Hi, start typing...',
//        notebookId: '3'),
  ];

  List<Note> get list => [..._list];

  List<Note> getListByNotebookId(String id) {
    return [..._list.where((note) => note.notebookId == id)];
  }

  Note getNoteById(id) {
    return _list.firstWhere((note) => note.id == id, orElse: () => null);
  }

  Future<String> addNote(Note n) async {
    final date = DateTime.now();
    final note = Note(
        id: date.toString(),
        title: n.title,
        timestamp: date,
        body: n.body,
        notebookId: n.notebookId,
        bookmark: false,
        tags: n.tags);

    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      Map<String, dynamic> data = {
        'title': note.title,
        'timestamp': FieldValue.serverTimestamp(),
        'body': note.body,
        'bookmark':false,
        'notebookID': note.notebookId,
        'tags': note.tags.toList(),
      };
      final value = await firestoreInstance
          .collection('notes')
          .document(user.uid)
          .collection('user_notes')
          .add(data);
      if (value != null) {
        final retrievedNote = Note(
          id: value.documentID,
          title: note.title,
          timestamp: note.timestamp,
          body: note.body,
          notebookId: note.notebookId,
          tags: note.tags.toList(),
        );
        _list.insert(0,retrievedNote);
        notifyListeners();
        return retrievedNote.id;
      }
    } catch (error) {
      throw error;
    }
    return null;
  }

  Future<void> deleteNote(id) async {
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      await firestoreInstance.collection('notes').document(user.uid).collection(
          'user_notes').document(id).delete().then((_) {
        _list.removeWhere((note) => note.id == id);
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteNotesByNotebookId(String notebookId) async {
    final user = await FirebaseAuth.instance.currentUser();
    final firestoreInstance = Firestore.instance;
    try {
      final notes = await firestoreInstance.collection('notes').document(
          user.uid).collection('user_notes').where(
          'notebookID', isEqualTo: notebookId).getDocuments();
//      print(notebookId);

      final batch = firestoreInstance.batch();
      if (notes != null && notes.documents.length > 0) {
//        print(notes.documents.length);
        notes.documents.forEach((element) {
          batch.delete(element.reference);
        });
        batch.commit();
        _list.removeWhere((note) => note.notebookId == notebookId);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

    Future<void> fetchNotes() async {
      final user = await FirebaseAuth.instance.currentUser();
      final firestoreInstance = Firestore.instance;
      try {
        var res = await firestoreInstance
            .collection('notes')
            .document(user.uid)
            .collection('user_notes')
            .getDocuments();
        if (res.documents.isNotEmpty) {
          _list.clear();
          List<Note> unSortedList = [];
          res.documents.forEach((document) {
            Note note = Note(
              id: document.documentID,
              title: document['title'],
              timestamp: document['timestamp'].toDate(),
              body: document['body'],
              bookmark: document['bookmark']??false,
              notebookId: document['notebookID'],
              tags: List.from(document['tags']),
            );
            unSortedList.add(note);
            // print(_list.length);
          });
          unSortedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          _list.addAll(unSortedList);
          initialFetch = true;
          notifyListeners();
        }
      } catch (error) {
        throw error;
      }
    }
  }

