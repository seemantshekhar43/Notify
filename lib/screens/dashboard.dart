import 'dart:convert';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:flushbar/flushbar.dart';
import 'package:notify/screens/add_image_text_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:notify/constant.dart';
import 'package:notify/firebase/auth_helper.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/utilities/api_helper.dart';
import 'package:notify/utilities/http_exception.dart';
import 'package:notify/utilities/version_manager.dart';
import 'package:provider/provider.dart';
import 'package:notify/screens/notebooks_list_screen.dart';
import 'package:notify/screens/notes_list_screen.dart';
import 'package:notify/widgets/add_note.dart';
import 'package:notify/widgets/add_notebook.dart';
import 'package:notify/widgets/notebooks_list.dart';
import 'package:notify/widgets/notes_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum MenuOptions {
  logOut,
}

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = false;
  String _userName = '';
  bool _updatingProfile = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    _checkScreenshots();
    _fetchNotesAndNotebooks();
    super.initState();
  }

  void _fetchNotesAndNotebooks() async {
    setState(() {
      _isLoading = true;
    });

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _userName = user.displayName ?? '';
    });
    try {
      await Provider.of<Notebooks>(context, listen: false).fetchNotebooks();
      await Provider.of<Notes>(context, listen: false).fetchNotes();
    } catch (error) {
      Flushbar(
        message: 'Unable to Fetch Data.',
        duration: Duration(seconds: 3),
      )..show(context);
    }

    setState(() {
      _isLoading = false;
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceSize size = DeviceSize(context: context);
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Image.asset(
            'assets/images/icon_white.png',
            width: size.width * 0.07,
            height: size.width * 0.07,
          ),
        ),
        title: GestureDetector(
          onLongPress: () async {
            final _formKey = GlobalKey<FormState>();
            await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      title: Text(
                        'Update Username',
                        textScaleFactor: 1.0,
                      ),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: _userName,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter username'
                          ),
                          validator: (value){
                            if(value.isEmpty)
                              return 'Enter a valid username';
                            return null;
                          },
                          onSaved: (value) {
                            _userName = value;
                          },
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'Cancel',
                            textScaleFactor: 1.0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        (_updatingProfile)? SpinKitWave( color: Theme.of(context).primaryColor,):FlatButton(
                          child: Text(
                            'Update',
                            textScaleFactor: 1.0,
                          ),
                          onPressed: () async{
                            final isValid = _formKey.currentState.validate();
                            if (!isValid) return;
                            _formKey.currentState.save();
                            setState(() {
                              _updatingProfile = true;
                            });
                           try{
                             final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
                             FirebaseUser user = await FirebaseAuth.instance.currentUser();
                             userUpdateInfo.displayName = _userName;
                              user.updateProfile(userUpdateInfo);
                           }catch(error){
                             Flushbar(
                               message: 'Failed to change username',
                               duration: Duration(seconds: 3),
                             )..show(context);
                           }
                            setState(() {
                              _updatingProfile = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ));
          },
          child: Text(
            'Hi, $_userName',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        titleSpacing: size.width * 0.005,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _startFloating();
            },
            child: Icon(
              Icons.camera,
            ),
          ),
          PopupMenuButton(
            onSelected: (MenuOptions option) {
              if (option == MenuOptions.logOut) FirebaseAuthHelper().logout();
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Log Out',
                  textScaleFactor: 1.0,
                ),
                value: MenuOptions.logOut,
              ),
            ],
          ),
        ],
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
                    builder: (context) => Wrap(
                          children: <Widget>[AddNotebook()],
                        ));
              }),
          SpeedDialChild(
              child: Icon(Icons.note_add),
              label: 'Add Note',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Wrap(
                          children: <Widget>[AddNote()],
                        ));
              }),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(),
        controller: _refreshController,
        onRefresh: _fetchNotesAndNotebooks,
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            children: <Widget>[
//              Row(
//                children: <Widget>[
//                  CircleAvatar(
//                    backgroundImage: AssetImage('assets/images/icon_blue.png'),
//                    radius: 20,
//                  ),
//                  SizedBox(width: size.width*0.05,),
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text('Hi, $_userName !', textScaleFactor: 1.0, style: TextStyle(
//                        color: Colors.black54,
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.bold,
//                      ),),
//                      SizedBox(height: size.height*0.01,),
//                      Text('Welcome back', textScaleFactor: 1.0, style: TextStyle(
//                        color: Colors.black38,
//                        fontSize: 14.0
//                      ),)
//                    ],
//                  ),
//                  Spacer(),
//                   Icon(Icons.camera, size: 20,),
//                  Icon(Icons.more_vert),
//                ],
//              ),
//              SizedBox(height: size.height*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Notebooks',
                    textScaleFactor: 1.0,
                    style: kLabelTextStyle,
                  ),
                  FlatButton(
                    child: Text(
                      'Show All',
                      textScaleFactor: 1.0,
                      style: kLabelButtonTextStyle(context),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, NotebooksListScreen.routeName);
                    },
                  )
                ],
              ),
              Container(
                  width: double.infinity,
                  height: size.height * 0.3,
                  child: (_isLoading)
                      ? Center(
                          child: SpinKitDoubleBounce(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : NotebooksList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Notes',
                    textScaleFactor: 1.0,
                    style: kLabelTextStyle,
                  ),
                  FlatButton(
                    child: Text(
                      'Show All',
                      textScaleFactor: 1.0,
                      style: kLabelButtonTextStyle(context),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, NotesListScreen.routeName);
                    },
                  )
                ],
              ),
              Expanded(
                child: (_isLoading)
                    ? Center(
                        child: SpinKitDoubleBounce(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : NotesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startFloating() async {
    try {
      String res = await kPlatform.invokeMethod<String>("startFloating");
      print(res);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _checkScreenshots() async {
    String res = '';
    try {
      res = await kPlatform.invokeMethod("getStatus");
      if (res.isNotEmpty) {
        print('path is: $res');
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => RenderImage(path: res),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

class RenderImage extends StatefulWidget {
  final String path;

  RenderImage({this.path});

  @override
  _RenderImageState createState() => _RenderImageState();
}

class _RenderImageState extends State<RenderImage> {
  String _markdownText;
  bool _isLoading = false;
  File _image;
  String path;

  _convert() async {
    //convert image to text
    setState(() {
      _isLoading = true;
    });

    try {
      final text = await renderImageToText(widget.path);
      if (text.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _markdownText = text;
        });
      } else {
        Flushbar(
          message: 'Image can\'t be converted into text.',
          duration: Duration(seconds: 3),
        )..show(context);
      }

//      await Future.delayed(
//          Duration(seconds: 5)
//      );
    } on HttpException catch (error) {
      Flushbar(
        message: error.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    } catch (error) {
      Flushbar(
        message: "Converting To Text Failed!",
        duration: Duration(seconds: 3),
      )..show(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    path = widget.path;
    _image = File(path);
    super.initState();
  }


  Future<void> getimageditor() async{
    var decodedImage = await decodeImageFromList(_image.readAsBytesSync());
    final width = decodedImage.width;
    final height =decodedImage.height;

    final geteditimage =
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        appBarColor: Colors.blue,
        bottomBarColor: Colors.blue,
        image: _image,
        iWidth: width,
        iHeight: height,
      );
    })).then((geteditimage) {
      if (geteditimage != null) {
        setState(() {
          _image = geteditimage;
          path = _image.path;
        });
      }
    }).catchError((er) {
      print(er);
    });
  }




  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.03),
        height: size.height * 0.55,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Convert To Text Note',
                  textScaleFactor: 1.0,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                ),
                IconButton(icon: Icon(Icons.brush),
                onPressed: (){

                  getimageditor();
                },)
              ],
            ),
            SizedBox(height: size.height * 0.03),
            Center(
              child: Container(
                height: size.height * 0.3,
                width: size.height * 0.3,
                child: Image.file(File(path)),
              ),
            ),
            Spacer(),
            (Provider.of<VersionManager>(context, listen: false).version ==
                    Version.version_1)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      OutlineButton(
                        splashColor: Theme.of(context).primaryColor,
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: size.width * 0.06),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: size.width * 0.06),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          final bytes = File(path).readAsBytesSync();
                          String img64 = base64Encode(bytes);
                          _markdownText =
                              '<img width="100%" src="data:image/png;base64, $img64">';

                          Navigator.of(context).popAndPushNamed(AddImageTextScreen.routeName, arguments: _markdownText);
//                          showModalBottomSheet(
//                              context: context,
//                              isScrollControlled: true,
//                              builder: (context) => Wrap(
//                                    children: <Widget>[
//                                      AddNote(
//                                        markdownContent: _markdownText,
//                                      )
//                                    ],
//                                  ));

                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          (_markdownText != null) ? 'Add Text' : 'Add Image',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      (_isLoading)
                          ? Center(
                              child: SpinKitWave(
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : OutlineButton(
                              splashColor: Theme.of(context).primaryColor,
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: size.width * 0.06),
                              color: Colors.white,
                              onPressed: () {
                                if (_markdownText != null)
                                  Navigator.of(context).pop();
                                else
                                  _convert();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                (_markdownText != null)
                                    ? 'Cancel'
                                    : 'Convert To Text',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: size.width * 0.06),
                        color: Theme.of(context).primaryColor,
                        disabledColor: Colors.blueAccent.shade100,
                        onPressed: (_isLoading)
                            ? null
                            : () async {
                                if (_markdownText == null) {
                                  final bytes =
                                      File(path).readAsBytesSync();
                                  String img64 = base64Encode(bytes);
                                  _markdownText =
                                      '<img width="100%" src="data:image/png;base64, $img64">';
                                }

//                                Navigator.of(context).pop();
//                                showModalBottomSheet(
//                                    context: context,
//                                    isScrollControlled: true,
//                                    builder: (context) => Wrap(
//                                          children: <Widget>[
//                                            AddNote(
//                                              markdownContent: _markdownText,
//                                            )
//                                          ],
//                                        ));
                          Navigator.of(context).popAndPushNamed(AddImageTextScreen.routeName, arguments: _markdownText);
                              },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          (_markdownText != null) ? 'Add Text' : 'Add Image',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
