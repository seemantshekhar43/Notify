import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/note.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/screens/note_detail_screen.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  bool _isLoading = false;
  bool _isSaved = false;
  var _title = '';
  var _notebookId = '';
  final _formKey = GlobalKey<FormState>();
  var _noteId ='';
  var _description = '';


  void _save(){
    final isValid = _formKey.currentState.validate();
    if (!isValid || _notebookId.isEmpty) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final note = Note(
      id: DateTime.now().toString(),
      title: _title,
      description: _description,
      content: 'Hi, start typing...',
      notebookId: _notebookId,
      date: DateTime.now(),
    );
    _noteId = Provider.of<Notes>(context, listen: false).addNote(note);
    setState(() {
      _isLoading = false;
      _isSaved  = true;
    });
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final notebooksData = Provider.of<Notebooks>(context, listen: false);
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
                    "Add New Note",
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
//                    initialValue: _name,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Note title can\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Title', hintText: 'Enter Note title'),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  TextFormField(
//                    initialValue: _name,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return 'Note title can\'t be empty';
//                      }
//                      return null;
//                    },
                    onSaved: (value) {
                      _description = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Description', hintText: 'Describe your note...'),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Choose Notebook',
                    style: kLabelTextStyle,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                      width: double.infinity,
                      height: size.height * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: notebooks.length,
                        itemBuilder: (context, i) {
                          return ChangeNotifierProvider.value(
                            value: notebooks[i],
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _notebookId = notebooks[i].id;
                                });

                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.02),
                                height: size.height*0.1,
                                width: size.width*0.4,
                                decoration: BoxDecoration(
                                  color: kLabelColorMap[notebooks[i].labelId],
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(color: Colors.transparent)
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:  EdgeInsets.all(size.width *0.04),
                                      child: Text(notebooks[i].title, style: kNotebookCardTitleTextStyle,),
                                    ),
                                    Center(
                                      child: (_notebookId == notebooks[i].id)? CircleAvatar(
                                        child: Icon(Icons.check),
                                      ):null,
                                    ),
                                  ],
                                ),

                              ),
                            ),
                          );
                        },
                      ),),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Center(
                    child:  (_isLoading)
                        ? CircularProgressIndicator()
                        : FlatButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: size.width * 0.06),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if(!_isSaved){
                          _save();
                        }

                        else{
                          Navigator.pop(context);
                          Navigator.pushNamed(context, NoteDetailScreen.routeName, arguments: _noteId);
                        }


                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        (_isSaved)?'Next':'Add Notebook',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                ],
              ),
            )),
      ),
    );
  }
}
