import 'package:flutter/material.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/widgets/notebook_item.dart';
import 'package:provider/provider.dart';

class NotebooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notebooksData = Provider.of<Notebooks>(context);
    final notebooks = notebooksData.list;

    return ListView.builder(
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
