import 'package:flutter/material.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/widgets/note_item.dart';
import 'package:provider/provider.dart';

class NotesList extends StatelessWidget {
  final notebookId;
  NotesList({this.notebookId});
  @override
  Widget build(BuildContext context) {
    final notesData = Provider.of<Notes>(context);
    final notes = (notebookId != null) ? notesData.getListByNotebookId(notebookId) :  notesData.list;

    return ListView.builder(

      itemCount: notes.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: notes[i],
          child: NoteItem(),
        );
      },
    );
  }
}
