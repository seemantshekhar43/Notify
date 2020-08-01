import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/note.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/screens/note_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SearchNoteItem extends StatelessWidget {
  final Function closeCallback;
  SearchNoteItem(this.closeCallback);

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    final note = Provider.of<Note>(context, listen: true);
    return GestureDetector(
      onTap: () {
        closeCallback();
        Navigator.pushNamed(context, NoteDetailScreen.routeName,
            arguments: note.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        padding: EdgeInsets.only(
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
                  Text(
                    note.title,

                    textScaleFactor: 1.0,
                    style: kNoteTitleTextStyle,
                  ),
                  Spacer(),
                  Text(
                    DateFormat('dd/MM/yy').format(note.timestamp),
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
