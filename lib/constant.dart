
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


const kPlatform = const MethodChannel('com.seemantshekhar.notify/notify');
const kLabelTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16.0,
);

final kLabelButtonTextStyle =(BuildContext context)=> TextStyle(
  color: Theme.of(context).primaryColor,
);

const kNotebookCardTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);
const kNotebookCardCountTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 35.0,
  fontWeight: FontWeight.bold,
);
const kNoteTitleTextStyle =  TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const kNoteDateTextStyle =  TextStyle(
  color: Colors.black54,
  fontSize: 12.0,

);
const kNoteDateDetailTextStyle =  TextStyle(
  color: Colors.black54,
  fontSize: 14.0,

);

const kNoteDetailTitleTextStyle =  TextStyle(
  color: Colors.black54,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const kNoteDescriptionTextStyle =  TextStyle(
  color: Colors.black54,
  fontSize: 14.0,

);




const Map<String, Color> kLabelColorMap = {
  '1': Colors.purple,
  '2': Colors.green,
  '3': Colors.red,
  '4': Colors.blueAccent,
  '5': Colors.yellow,
  '6': Colors.orange,
  '7': Colors.indigo,
  '8': Colors.limeAccent,
  '9': Colors.teal,
  '10': Colors.blueGrey,
};

class DeviceSize {
  double height;
  double width;
  BuildContext context;

  DeviceSize({this.context}) {
    final size = MediaQuery.of(context).size;
    height = size.height - kBottomNavigationBarHeight;
    width = size.width;
  }
}
