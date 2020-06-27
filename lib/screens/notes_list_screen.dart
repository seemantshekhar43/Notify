import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/widgets/notes_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.note_add), label: 'Add Note', onTap: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width*0.02),
        child: NotesList(),
      ),

    );
  }
}
