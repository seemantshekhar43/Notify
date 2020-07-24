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

    return (notes.length<1)? Center(child: Text(
      'Nothing to display!! Add one!!',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18.0
      ),
    ),):ListView.builder(

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
