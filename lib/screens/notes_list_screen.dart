import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/utilities/version_manager.dart';
import 'package:notify/widgets/add_note.dart';
import 'package:notify/widgets/notes_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notify/widgets/search_widget.dart';
import 'package:provider/provider.dart';

enum FilterOption{
  all,
  bookmark
}
class NotesListScreen extends StatefulWidget {
  static const routeName = '/notes-list-screen';

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {

  bool _showBookmark = false;
  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          textScaleFactor: 1.0,
        ),
        actions: <Widget>[
          if(Provider.of<VersionManager>(context, listen:false).version == Version.version_2)IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: SearchNotes());
            },
          ),
          PopupMenuButton(
            onSelected: (FilterOption option){
              setState(() {

                if(option == FilterOption.bookmark)
                  _showBookmark = true;
                else
                  _showBookmark = false;
              });
            },
            icon: Icon(
                Icons.more_vert
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Bookmark'),
                value: FilterOption.bookmark,
              ),
              PopupMenuItem(
                child: Text('All Notes'),
                value: FilterOption.all,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.note_add), label: 'Add Note', onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Wrap(children: <Widget>[
                  AddNote()
                ],));
          }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width*0.02),
        child: NotesList(showBookmark: _showBookmark,),
      ),

    );
  }
}
