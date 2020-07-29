import 'package:flutter/material.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notify/screens/dashboard.dart';
import 'package:notify/screens/notebooks_list_screen.dart';
import 'package:notify/screens/notes_list_screen.dart';
import 'package:notify/widgets/add_note.dart';
import 'package:notify/widgets/add_notebook.dart';
import 'package:notify/widgets/notes_list.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class NotebookScreen extends StatelessWidget {
  static const routeName = 'notebook-screen';
  @override
  Widget build(BuildContext context) {
    final  id = ModalRoute.of(context).settings.arguments as String;
    final notebook = Provider.of<Notebooks>(context).findById(id);
    final size = DeviceSize(context: context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (notebook!= null)?kLabelColorMap[notebook.labelId]:Colors.red,
        title: Text(
          (notebook!= null)?notebook.title:'',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed:  (notebook!= null)?(){
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Wrap(children: <Widget>[
                    AddNotebook(notebookId: notebook.id,)
                  ],));
            }:null,
          )
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
                  AddNote(currentNotebookId:  notebook.id,)
                ],));
          }),
        ],
      ),
      body: (notebook!= null)? Padding(
        padding: EdgeInsets.all(size.width*0.02),
        child: NotesList(notebookId: notebook.id,),
      ):Center(child: Text('Notebook Deleted'),),
    );
  }
}
