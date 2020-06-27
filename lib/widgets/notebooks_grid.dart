import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/widgets/notebook_item.dart';
import 'package:provider/provider.dart';

class NotebooksGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = DeviceSize(context: context);
    print(size.width*0.4 / size.height*0.16);
    final notebooksData = Provider.of<Notebooks>(context);
    final notebooks = notebooksData.list;
    return GridView.builder(
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

