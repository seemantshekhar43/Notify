import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/widgets/notebook_item.dart';
import 'package:provider/provider.dart';

import 'add_notebook.dart';

class NotebooksGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = DeviceSize(context: context);
    print(size.width*0.4 / size.height*0.16);
    final notebooksData = Provider.of<Notebooks>(context);
    final notebooks = notebooksData.list;
    return (notebooks.length< 1)?
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
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                fontSize: 15.0),
          )
        ],
      ),
    )
        :GridView.builder(
      itemCount: notebooks.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: notebooks[i],
          child: NotebookItem(),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          childAspectRatio: 2 / 2.5,
          crossAxisSpacing: 10.0),
    );
  }
}

