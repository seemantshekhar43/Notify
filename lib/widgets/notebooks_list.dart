import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/widgets/notebook_item.dart';
import 'package:provider/provider.dart';

import 'add_notebook.dart';

class NotebooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notebooksData = Provider.of<Notebooks>(context);
    final notebooks = notebooksData.list;
    final size = DeviceSize(context: context);

    return (notebooks.length<1)?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.create_new_folder, color: Colors.black54,),
            iconSize: size.height * 0.06,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Wrap(
                    children: <Widget>[AddNotebook()],
                  ));
            },
          ),

          Text(
            'Add Notebook',
            textScaleFactor: 1.0,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                fontSize: 15.0),
          )
        ],
      ),
    )
        :ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: notebooks.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: notebooks[i],
          child: NotebookItem(),
        );
      },
    );
  }
}
