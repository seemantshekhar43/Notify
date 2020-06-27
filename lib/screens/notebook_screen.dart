import 'package:flutter/material.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notify/widgets/add_notebook.dart';
import 'package:notify/widgets/notes_list.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class NotebookScreen extends StatelessWidget {
  static const routeName = 'notebook-screen';
  @override
  Widget build(BuildContext context) {
    final  id = ModalRoute.of(context).settings.arguments as String;
    final notebook = Provider.of<Notebooks>(context, listen: true).findById(id);
    final size = DeviceSize(context: context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLabelColorMap[notebook.labelId],
        title: Text(
          notebook.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Wrap(children: <Widget>[
                    AddNotebook(notebookId: notebook.id,)
                  ],));
            },
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.note_add), label: 'Add Note', onTap: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width*0.02),
        child: NotesList(notebookId: notebook.id,),
      ),
    );
  }
}
