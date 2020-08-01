import 'package:flutter/material.dart';
import 'package:notify/widgets/add_notebook.dart';
import 'package:notify/widgets/notebooks_grid.dart';
import '../constant.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NotebooksListScreen extends StatelessWidget {

  static const routeName = 'notebooks-list-screen';
  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notebooks',textScaleFactor: 1.0,),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.create_new_folder),
              label: 'Add Notebook',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Wrap(children: <Widget>[
                      AddNotebook()
                    ],));
              }),
//          SpeedDialChild(
//              child: Icon(Icons.note_add), label: 'Add Note', onTap: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: NotebooksGrid(),
      ),
    );
  }
}
