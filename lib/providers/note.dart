import 'package:flutter/foundation.dart';

class Note extends ChangeNotifier {
  final String id;
   String title;
   List<String> tags;
   String content;
   String notebookId;
   DateTime date;
  bool isStarred;

  Note(
      {@required this.id,
      @required this.title,
       this.tags,
      @required this.notebookId,
      @required this.date,
       @required this.content,
      this.isStarred = false}){
   if(tags == null){
     tags = List<String>();
   }
  }

  void toggleStarStatus(){
    isStarred = !isStarred;
    notifyListeners();
  }

  void updateContent(String content){
    this.content =content;
    this.date = DateTime.now();
    notifyListeners();
  }
  void updateDetails(List<String> tags, String title, String notebookId){
    this.tags =tags;
    this.title = title;
    this.notebookId = notebookId;
    notifyListeners();
  }
}

