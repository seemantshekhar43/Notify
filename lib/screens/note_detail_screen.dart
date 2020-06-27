import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/note.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/screens/edit_note_screen.dart';
import 'package:html_editor/html_editor.dart';
import 'package:provider/provider.dart';

class NoteDetailScreen extends StatefulWidget {
  static const routeName = '/note-detail-screen';

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  var _noteId;
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  String result = "";

  @override
  void didChangeDependencies() {
    _noteId = ModalRoute.of(context).settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _note =
        Provider.of<Notes>(context, listen: false).getNoteById(_noteId);
    final size = DeviceSize(context: context);
    return ChangeNotifierProvider<Note>.value(
      value: _note,
      child: Consumer<Note>(
        builder: (context, note, child) => Scaffold(
          appBar: AppBar(
            title: Text(note.title),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  note.toggleStarStatus();
                },
                icon: Icon(
                  (note.isStarred) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: size.width * 0.04,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          DateFormat.yMMMMd('en_US').add_Hm().format(note.date),
                          style: kNoteDateDetailTextStyle,
                        ),
                        Spacer(),
                        Container(
                          //padding: EdgeInsets.only(left: size.width*0.01),
                          width: size.width * 0.45,
                          child: GestureDetector(
                            onTap: () {
                              //TODO implement change notebook feature
                            },
                            child: Text(
                              Provider.of<Notebooks>(context, listen: false)
                                  .findById(note.notebookId)
                                  .title,
                              style: kNoteDetailTitleTextStyle,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                      child:HtmlEditor(
                        //showBottomToolbar: false,
                        useBottomSheet: true,
                        //hint: "Your text here...",
                        value: note.content,
                        key: keyEditor,
                        height: size.height*0.6,
                      ),


//                    Text(
//                      note.description,
//                      style: TextStyle(
//                        color: Color(0xff000000),
//                        fontSize: 18.0,
//                      ),
//                    ),
                    ),
                    FlatButton(
                      child: Text('save'),
                      onPressed: () async{
                        final txt = await keyEditor.currentState.getText();
                        note.content = txt;
                       // print(txt);
                        note.updateNote(note);
                      },
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
