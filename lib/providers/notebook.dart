import 'package:flutter/foundation.dart';

class Notebook extends ChangeNotifier {
  final String id;
  final String title;
  final String labelId;
//  List<String> notesList;
//  final DateTime date;
  //bool isStarred;

  Notebook({
    @required this.id,
    @required this.title,
    @required this.labelId,
  });

}
