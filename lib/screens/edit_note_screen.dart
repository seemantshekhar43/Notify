import 'package:flutter/material.dart';
import 'package:notify/providers/note.dart';
import 'package:provider/provider.dart';

class EditNoteScreen extends StatefulWidget {

  static const routeName = 'edit-note-screen';
  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {

  @override
  Widget build(BuildContext context) {
    final _note = Provider.of<Note>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _note.title,
          textScaleFactor: 1.0,
        ),
      ),
      body: Center(
        child: Text(
          _note.tags.length.toString(),
          textScaleFactor: 1.0,
        ),
      ),
    );
  }
}
