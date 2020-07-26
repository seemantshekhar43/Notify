import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:path_provider/path_provider.dart';
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
    _checkScreenshots();
    _fetchNotesAndNotebooks();
    super.initState();
  }

  void _fetchNotesAndNotebooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Notebooks>(context, listen: false).fetchNotebooks();
      await Provider.of<Notes>(context, listen: false).fetchNotes();
    } catch (error) {
      Scaffold. of(context).showSnackBar(SnackBar(
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
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : NotebooksList()),
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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : NotesList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startFloating() async {
    try {
      String res = await kPlatform.invokeMethod<String>("startFloating");
      print(res);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _checkScreenshots() async {
    String res = '';
    try {

      res = await kPlatform.invokeMethod("getStatus");
      if (res.isNotEmpty) {
        print('path is: $res');
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => RenderImage(path: res),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

class RenderImage extends StatefulWidget {
  final String path;

  RenderImage({this.path});

  @override
  _RenderImageState createState() => _RenderImageState();
}

class _RenderImageState extends State<RenderImage> {
  String _markdownText;
  bool _isLoading = false;

  _convert() async{
    //convert image to text
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _markdownText = 'Text to image';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.05, vertical: size.height*0.03),
        height: size.height * 0.55,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
             'Convert To Text Note',
              style:
              TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            ),
            SizedBox(height: size.height * 0.03),
            Center(
              child: Container(
                height: size.height * 0.3,
                width: size.height*0.3,
                child: Image.file(File(widget.path)),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlineButton(
                  splashColor: Theme.of(context).primaryColor,
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  padding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: size.width * 0.06),
                  color: Colors.white,
                  onPressed: ()  {
                    Navigator.of(context).pop();

                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                (_isLoading)? CircularProgressIndicator() :FlatButton(
                  padding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: size.width * 0.06),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if(_markdownText!= null){
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Wrap(
                            children: <Widget>[AddNote(markdownContent: _markdownText,)],
                          ));
                    }else{
                      _convert();
                    }

                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    (_markdownText!= null)? 'Next' :'Convert To Text',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

