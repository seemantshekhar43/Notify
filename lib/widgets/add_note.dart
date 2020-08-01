import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/note.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notify/screens/note_detail_screen.dart';
import 'package:notify/utilities/version_manager.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

import 'add_notebook.dart';

class AddNote extends StatefulWidget {
  final noteId;
  final currentNotebookId;
  final markdownContent;

  AddNote(
      {this.noteId,
      this.currentNotebookId,
      this.markdownContent: 'Hi, Start Typing...'});
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  bool _isLoading = false;
  bool _isLoadingDelete = false;
  final _tagController = TextEditingController();
  bool _isSaved = false;
  var _title = '';
  var _notebookId = '';
  final _formKey = GlobalKey<FormState>();
  var _noteId = '';
  var _tags = List<String>();
  var _content = '';

  @override
  void initState() {
    super.initState();

    if (widget.noteId != null) {
      Note note = Provider.of<Note>(context, listen: false);
      _title = note.title;
      _tags = note.tags;
      _notebookId = note.notebookId;
    }
    if (widget.currentNotebookId != null) {
      _notebookId = widget.currentNotebookId;
    }
  }

  void _updateNote() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid || _notebookId.isEmpty) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Note>(context, listen: false)
          .updateDetails(_tags, _title, _notebookId);
    } catch (error) {}

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    if (_notebookId.isEmpty) {
      Flushbar(
        message: "Add notebook first",
        duration: Duration(seconds: 3),
      )..show(context);
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final note = Note(
      id: DateTime.now().toString(),
      title: _title,
      tags: _tags,
      body: widget.markdownContent,
      notebookId: _notebookId,
      timestamp: DateTime.now(),
    );
    try {
      _noteId = await Provider.of<Notes>(context, listen: false).addNote(note);
      if (_noteId != null) Navigator.pop(context);
      Navigator.pushNamed(context, NoteDetailScreen.routeName,
          arguments: _noteId);
    } catch (error) {
      Flushbar(
        message: 'Adding note failed!',
        duration: Duration(seconds: 3),
      )..show(context);
    }
    setState(() {
      _isLoading = false;
      _isSaved = true;
    });
  }

  Future<void> _delete() async {
    setState(() {
      _isLoadingDelete = true;
    });
    try {
      await Provider.of<Notes>(context, listen: false)
          .deleteNote(widget.noteId);
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      return;
    } catch (error) {}

    setState(() {
      _isLoadingDelete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notebooksData = Provider.of<Notebooks>(context, listen: true);
    final notebooks = notebooksData.list;
    final size = DeviceSize(context: context);
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (widget.noteId != null) ? 'Edit note' : 'Add New Note',
                    textScaleFactor: 1.0,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
                    initialValue: _title,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Note title can\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value.trim();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title', hintText: 'Enter Note title'),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  if(Provider.of<VersionManager>(context, listen:false).version == Version.version_2)TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _tagController,
                    onFieldSubmitted: (value) {
                      setState(() {
                        if (value.trim().isNotEmpty &&
                            !_tags.contains(value.trim())){
                          _tags.insert(0, value.trim());
                          _tagController.clear();

                        }

                      });
                    },
                    textAlign: TextAlign.center,
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return 'Tag can\'t be empty';
//                      }
//                      return null;
//                    },
                    decoration: InputDecoration(
                        labelText: 'Tag', hintText: 'Add Tags...'),
                  ),
                  if(Provider.of<VersionManager>(context, listen:false).version == Version.version_2)SizedBox(
                    height: size.height * 0.01,
                  ),
                  if (_tags.length > 0)
                    Container(
                      width: double.infinity,
                      height: size.height * 0.05,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tags.length,
                        itemBuilder: (context, i) {
                          return Padding(

                            padding: const EdgeInsets.symmetric(horizontal:4.0),
                            child: Chip(
                              label: Text(
                                _tags[i],
                                textScaleFactor: 1.0,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.black54,
                              deleteIcon: Icon(Icons.cancel),
                              onDeleted: () {
                                setState(() {
                                  _tags.removeAt(i);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Text(
                    'Choose Notebook',
                    textScaleFactor: 1.0,
                    style: kLabelTextStyle,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    width: double.infinity,
                    height: size.height * 0.3,
                    child: (notebooks.length < 1)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.create_new_folder, color: Colors.black54,),
                                  iconSize: size.height * 0.06,
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => Wrap(
                                              children: <Widget>[AddNotebook()],
                                            ));
                                  },
                                ),

                                Text(
                                  'Add notebook first',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 18.0),
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: notebooks.length,
                            itemBuilder: (context, i) {
                              return ChangeNotifierProvider.value(
                                value: notebooks[i],
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _notebookId = notebooks[i].id;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.02,
                                        vertical: size.height * 0.02),
                                    height: size.height * 0.1,
                                    width: size.width * 0.4,
                                    decoration: BoxDecoration(
                                      color:
                                          kLabelColorMap[notebooks[i].labelId],
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(color: Colors.transparent)
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.04),
                                          child: Text(
                                            notebooks[i].title,
                                            textScaleFactor: 1.0,
                                            style: kNotebookCardTitleTextStyle,
                                          ),
                                        ),
                                        Center(
                                          child:
                                              (_notebookId == notebooks[i].id)
                                                  ? CircleAvatar(
                                                      child: Icon(Icons.check),
                                                    )
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      if (widget.noteId != null)
                        (_isLoadingDelete)
                            ?  SpinKitPulse(
                    color: Theme.of(context).errorColor,
                  )
                            : FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: size.width * 0.06),
                                color: Theme.of(context).errorColor,
                                onPressed: () async {
                                  final response = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            title: Text('Delete Note', textScaleFactor: 1.0,),
                                            content: Text(
                                                '$_title will be deleted, are you sure you want to delete?', textScaleFactor: 1.0,),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel', textScaleFactor: 1.0,),
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Yes', textScaleFactor: 1.0,),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              ),
                                            ],
                                          ));
                                  if (response) {
                                    _delete();
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  'Delete',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      (_isLoading)
                          ? SpinKitThreeBounce(
                        color: Theme.of(context).primaryColor,
                      )
                          : FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: size.width * 0.06),
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                if (widget.noteId != null) {
                                  _updateNote();
//                            Navigator.of(context).pop();
                                } else {
                                  await _save();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                (widget.noteId != null) ? 'Save' : 'Add Note',
                                textScaleFactor: 1.0,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
