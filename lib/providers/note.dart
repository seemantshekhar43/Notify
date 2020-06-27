import 'package:flutter/foundation.dart';

class Note extends ChangeNotifier {
  final String id;
   String title;
   String description;
   String content;
   String notebookId;
   DateTime date;
  bool isStarred;

  Note(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.notebookId,
      @required this.date,
       @required this.content,
      this.isStarred = false});

  void toggleStarStatus(){
    isStarred = !isStarred;
    notifyListeners();
  }

  void updateNote(Note note){
    this.title = note.title;
    this.description = note.description;
    this.date = note.date;
    this.isStarred = note.isStarred;
    this.notebookId = note.notebookId;
    this.content = note.content;
    notifyListeners();
  }
}

