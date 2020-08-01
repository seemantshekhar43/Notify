import 'package:flutter/material.dart';
enum Version{
  version_1,
  version_2,
  version_3
}
class VersionManager extends ChangeNotifier {
  final Version version;

  VersionManager({this.version:Version.version_1});
}