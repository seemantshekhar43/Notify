import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/screens/note_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:notify/screens/notebooks_list_screen.dart';
import 'package:notify/screens/notes_list_screen.dart';
import 'package:notify/widgets/add_note.dart';
import 'package:notify/widgets/add_notebook.dart';
import 'package:notify/widgets/notebooks_list.dart';
import 'package:notify/widgets/notes_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = false;
  @override
  void initState() {
    _fetchNotesAndNotebooks();
    super.initState();
  }

  void _fetchNotesAndNotebooks() async{
    setState(() {
      _isLoading = true;
    });

    try{
      await Provider.of<Notebooks>(context, listen: false).fetchNotebooks();
      await Provider.of<Notes>(context,listen: false).fetchNotes();
    } catch(error){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Error Loading data'),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final DeviceSize size = DeviceSize(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () {
              _startFloating();
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.create_new_folder),
              label: 'Add Notebook',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Wrap(
                          children: <Widget>[AddNotebook()],
                        ));
              }),
          SpeedDialChild(
              child: Icon(Icons.note_add),
              label: 'Add Note',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Wrap(
                          children: <Widget>[AddNote()],
                        ));
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Notebooks',
                  style: kLabelTextStyle,
                ),
                FlatButton(
                  child: Text(
                    'Show All',
                    style: kLabelButtonTextStyle(context),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, NotebooksListScreen.routeName);
                  },
                )
              ],
            ),
            Container(
                width: double.infinity,
                height: size.height * 0.3,
                child: _isLoading? Center(child: CircularProgressIndicator(),): NotebooksList()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Notes',
                  style: kLabelTextStyle,
                ),
                FlatButton(
                  child: Text(
                    'Show All',
                    style: kLabelButtonTextStyle(context),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, NotesListScreen.routeName);
                  },
                )
              ],
            ),
            Expanded(
              child: _isLoading? Center(child: CircularProgressIndicator(),):NotesList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startFloating() async {
    String res = '';
    try {
      res = await kPlatform.invokeMethod("startFloating");
    } catch (e) {
      print(e);
    }

    if (res.isNotEmpty) {
      print(res);
    }
  }
}
