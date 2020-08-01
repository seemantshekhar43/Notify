import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/widgets/note_item.dart';
import 'package:notify/widgets/search_note_item.dart';
import 'package:provider/provider.dart';

class SearchNotes extends SearchDelegate<NoteItem> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return<Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final size = DeviceSize(context: context);
    final notes = Provider.of<Notes>(context, listen: false).list;
    final sNotes = (query.isNotEmpty)? notes.where((element) {
      bool status = false;
      element.tags.forEach((String tag) {
        if (tag.toLowerCase().contains(query.trim().toLowerCase())) status = true;
      });
      return status;
    }).toList(): notes;

    return (notes.length<1)? Center(child: Text(
      'Nothing to display!! Add one!!',
      textScaleFactor: 1.0,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18.0
      ),
    ),):Padding(
      padding: EdgeInsets.all(size.width*0.02),
      child: ListView.builder(

        itemCount: sNotes.length,
        itemBuilder: (context, i) {
          return ChangeNotifierProvider.value(
            value: sNotes[i],
            child: SearchNoteItem((){
              close(context, null);
            }),
          );
        },
      ),
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final size = DeviceSize(context: context);
    final notes = Provider.of<Notes>(context, listen: false).list;
    final sNotes = (query.isNotEmpty)? notes.where((element) {
      bool status = false;
      element.tags.forEach((String tag) {
        if (tag.toLowerCase().contains(query.trim().toLowerCase())) status = true;
      });
      return status;
    }).toList(): notes;

    return (notes.length<1)? Center(child: Text(
      'Nothing to display!! Add one!!',
      textScaleFactor: 1.0,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18.0
      ),
    ),):Padding(
      padding: EdgeInsets.all(size.width*0.02),
      child: ListView.builder(

        itemCount: sNotes.length,
        itemBuilder: (context, i) {
          return ChangeNotifierProvider.value(
            value: sNotes[i],
            child: SearchNoteItem((){
              close(context, null);
            }),
          );
        },
      ),
    );
  }

  



}
