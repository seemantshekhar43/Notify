import 'package:flutter/foundation.dart';

import 'package:notify/providers/notebook.dart';

class Notebooks extends ChangeNotifier {
  List<Notebook> _list = [
    Notebook(
      id: '1',
      title: 'Science and Technology',
      labelId: '1',
      date: DateTime.now(),
      notesList: [
        '1a', '1b', '1c'
      ],
    ),
    Notebook(
      id: '2',
      title: 'Mathematics',
      labelId: '9',
      date: DateTime.now(),
      notesList: [
       '2a', '2b', '2c'
      ],
    ),
    Notebook(
      id: '3',
      title: 'Language',
      labelId: '4',
      date: DateTime.now(),
      notesList: [
       '3a', '3b', '3c'
      ],
    ),
  ];

  List<Notebook> get list => [..._list];

  void addNotebook(Notebook notebook){
    _list.add(notebook);
    notifyListeners();
  }
  void deleteNotebook(id){
    _list.removeWhere((notebook) => notebook.id == id);
    notifyListeners();
  }

  Notebook findById(String id) {
    return _list.firstWhere((notebook) => notebook.id == id);
  }

  void updateNotebook(Notebook  notebook){
    final index = _list.indexWhere((nBook) => notebook.id == nBook.id);
    _list[index] = notebook;
    notifyListeners();
  }


}
