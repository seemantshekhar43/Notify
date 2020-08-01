import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/note.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/screens/note_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flushbar/flushbar.dart';

class NoteItem extends StatefulWidget {

  final String markdown;

  NoteItem({this.markdown:''});

  @override
  _NoteItemState createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    final note = Provider.of<Note>(context, listen: true);
    return GestureDetector(
      onTap: () async{
        if(widget.markdown.isNotEmpty){
          setState(() {
            _isLoading = true;
          });
          try{
            String updated = '${note.body}<br><p>${widget.markdown}</p>';
            await note.updateContent(updated);
          }catch(error){
            Flushbar(
              message: 'Unable to save data.',
              duration: Duration(seconds: 3),
            )..show(context);
          }
          setState(() {
            _isLoading =false;
          });
          Navigator.popAndPushNamed(context, NoteDetailScreen.routeName,
              arguments: note.id);
        }else
        Navigator.pushNamed(context, NoteDetailScreen.routeName,
            arguments: note.id);
      },
      child: Dismissible(
        key: ValueKey(note.id),
        background: Container(
          margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
          decoration: BoxDecoration(
            color:  (note.bookmark)?Theme.of(context).errorColor:Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.bookmark,
                  color: Colors.white,
                ),
                Text(
                  (note.bookmark)?'Remove Bookmark':'Bookmark',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        secondaryBackground: Container(
          margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
          decoration: BoxDecoration(
            color: Theme.of(context).errorColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Text(
                  " Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            alignment: Alignment.centerRight,
          ),
        ),

        confirmDismiss: (direction) {
          if(direction == DismissDirection.startToEnd){
            return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text((note.bookmark)?'Remove Bookmark':'Bookmark ${note.title}', textScaleFactor: 1.0,),
                  content: Text(
                    (note.bookmark)?'Bookmark will be removed from ${note.title}' :'Bookmark will be added to this note.', textScaleFactor: 1.0,),
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
                        try {
                          print('pressed');
                           note
                              .toggleBookmark();
                        } catch (error) {
                          Flushbar(
                            message: 'Unable to delete note.',
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                ));
          }else
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text('Delete ${note.title}', textScaleFactor: 1.0,),
                    content: Text(
                        'Note will be permanently deleted, are you sure you want to delete?', textScaleFactor: 1.0,),
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
        },
        onDismissed: (direction) async{
          if(direction == DismissDirection.endToStart){
            try {
              await Provider.of<Notes>(context, listen: false)
                  .deleteNote(note.id);
            } catch (error) {
              Flushbar(
                message: 'Unable to delete note.',
                duration: Duration(seconds: 3),
              )..show(context);
            }
          }

        },
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
              padding: EdgeInsets.only(
                  top: size.height*0.01,
                  left: size.width * 0.03,
                  right: size.width * 0.03,
                  bottom: size.height * 0.01),
              decoration: BoxDecoration(
                color: Color(0xfff2f4f5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Row(
                      children: <Widget>[

                        CircleAvatar(
                          radius: 5.0,
                          backgroundColor: kLabelColorMap[
                          Provider.of<Notebooks>(context, listen: false)
                              .findById(note.notebookId)
                              .labelId],
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        (_isLoading)? Expanded(
                          child: SpinKitThreeBounce(
                            color: Theme.of(context).primaryColor,
                          ),
                        ):Expanded(
                          child: Text(
                            note.title,
                            textScaleFactor: 1.0,
                            style: kNoteTitleTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Text(
                          DateFormat('dd/MM/yy').format(note.timestamp),
                          textAlign: TextAlign.right,
                          textScaleFactor: 1.0,
                          style: kNoteDateTextStyle,
                        ),

                      ],
                    ),
                  ),
                  if(note.tags.length>0)Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
                    height: size.height * 0.03,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: note.tags.length,
                      itemBuilder: (context, i) {
                        return customChip(note.tags[i]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if(note.bookmark)Positioned(child: Icon(Icons.bookmark), top: 0,right: 0,),
          ],
        ),
      ),
    );
  }

  Widget customChip(String label){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      margin:  EdgeInsets.symmetric(horizontal: 3.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Text(
        label,
        textScaleFactor: 1.0,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
