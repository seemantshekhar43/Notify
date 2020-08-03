import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/note.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:html_editor/html_editor.dart';
import 'package:notify/utilities/http_exception.dart';
import 'package:notify/widgets/add_note.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:share/share.dart';
import '../utilities/api_helper.dart' as apiHelper;

class NoteDetailScreen extends StatefulWidget {
  static const routeName = '/note-detail-screen';

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  var _noteId;
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  String message = '';
  bool _isLoading =false;
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
    return  (_note!= null)?ChangeNotifierProvider<Note>.value(
      value: _note,
      child: Consumer<Note>(
        builder: (context, note, child) => Scaffold(
          appBar: AppBar(
            title: (_note!= null)?Text(note.title, textScaleFactor: 1.0,):'',
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Wrap(
                        children: <Widget>[
                          ChangeNotifierProvider.value(
                              value: note,
                              child: AddNote(
                                noteId: note.id,
                              ))
                        ],
                      ));
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                    message = 'Saving Changes';
                  });
                  final txt = await keyEditor.currentState.getText();
                  try{
                    await note.updateContent(txt);
                    Flushbar(
                      message:  "Changes Saved Successfully!",
                      duration:  Duration(seconds: 3),
                    )..show(context);
                  }catch(error){
                    Flushbar(
                      message:  "Saving Changes Failed!",
                      duration:  Duration(seconds: 3),
                    )..show(context);
                  }
                  setState(() {
                    _isLoading = false;

                  });
                },
                icon: Icon(Icons.save),
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () async{
                  setState(() {
                    _isLoading = true;
                    message = 'Generating Link';
                  });
                  try{
                    String url = await apiHelper.getShareableLink(note);
                    if(url.isNotEmpty){
                      setState(() {
                        _isLoading = false;
                      });
                      Share.share(url);
                    }else {
                      Flushbar(
                        message: "Shareable link generation failed!",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }

                  } on HttpException catch (error) {
                    Flushbar(
                      message: error.toString(),
                      duration: Duration(seconds: 3),
                    )..show(context);
                  } catch (error) {
                    Flushbar(
                      message: "Shareable link generation failed!",
                      duration: Duration(seconds: 3),
                    )..show(context);
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
            ],
          ),
          body:  (_note!= null)?Stack(
            children: <Widget>[

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Row(
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
                          DateFormat.yMMMMd('en_US').add_Hm().format(note.timestamp),
                          textScaleFactor: 1.0,
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
                              textScaleFactor: 1.0,
                              style: kNoteDetailTitleTextStyle,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    //padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                    child: HtmlEditor(
                      //showBottomToolbar: false,
                      useBottomSheet: true,
                      //hint: "Your text here...",
                      value: note.body,
                      key: keyEditor,
                      height: size.height * 0.6,
                    ),

//                    Text(
//                      note.description,
//                      style: TextStyle(
//                        color: Color(0xff000000),
//                        fontSize: 18.0,
//                      ),
//                    ),
                  ),
//                    FlatButton(
//                      child: Text('save'),
//                      onPressed: () async{
//                        final txt = await keyEditor.currentState.getText();
//                        note.content = txt;
//                       // print(txt);
//                        note.updateNote(note);
//                      },
//                    ),
                ],
              ),
              if(_isLoading) Center(
                child: Container(
                    width: size.width*0.5,
                    height: size.width*0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xff000000).withOpacity(0.4),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,

                        ),
                        SizedBox(height: size.width*0.05,),
                        Text(
                          message,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                        )
                      ], 
                    )),
              ),
            ],
          ): Center(child: Text('Note Deleted', textScaleFactor: 1.0,),),
        ),
      ),
    ): Center(child: Text('Note Deleted', textScaleFactor: 1.0,),);
  }
}
