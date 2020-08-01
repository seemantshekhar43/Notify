import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/providers/notebook.dart';
import 'package:notify/screens/notebook_screen.dart';
import 'package:provider/provider.dart';


class NotebookItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    final notebook = Provider.of<Notebook>(context, listen:false);
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, NotebookScreen.routeName, arguments: notebook.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.02),
        height: size.height*0.16,
        width: size.width*0.36,
        decoration: BoxDecoration(
          color: kLabelColorMap[notebook.labelId],
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.transparent)
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding:  EdgeInsets.all(size.width *0.04),
          child: Text(notebook.title, textScaleFactor: 1.0,style: kNotebookCardTitleTextStyle,),
        ),

      ),
    );
  }
}
