import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/widgets/add_note.dart';
import 'package:notify/widgets/note_item.dart';
import 'package:provider/provider.dart';

class NotesList extends StatelessWidget {
  final notebookId;

  NotesList({this.notebookId});
  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    final notesData = Provider.of<Notes>(context);
    final notes = (notebookId != null) ? notesData.getListByNotebookId(notebookId) :  notesData.list;

    return (notes.length<1)? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.note_add, color: Colors.black54,),
            iconSize: size.height * 0.06,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Wrap(
                    children: <Widget>[AddNote()],
                  ));
            },
          ),

          Text(
            'Add First note',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                fontSize: 15.0),
          )
        ],
      ),
    ):ListView.builder(

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
