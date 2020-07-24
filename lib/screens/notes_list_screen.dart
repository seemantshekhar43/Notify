import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/widgets/add_note.dart';
import 'package:notify/widgets/notes_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notify/widgets/search_widget.dart';

class NotesListScreen extends StatelessWidget {
  static const routeName = '/notes-list-screen';

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes'
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: SearchNotes());
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.note_add), label: 'Add Note', onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Wrap(children: <Widget>[
                  AddNote()
                ],));
          }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width*0.02),
        child: NotesList(),
      ),

    );
  }
}
