import 'package:notify/providers/notebook.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:notify/constant.dart';

class AddNotebook extends StatefulWidget {
  final notebookId;

  AddNotebook({this.notebookId});
  @override
  _AddNotebookState createState() => _AddNotebookState();
}

class _AddNotebookState extends State<AddNotebook> {
  List<String> _list;
  var _name = '';
  var _labelId = '1';
  var _isLoadingSave = false;
  var _isLoadingDelete = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.notebookId != null) {
      Notebook notebook = Provider.of<Notebooks>(context, listen: false)
          .findById(widget.notebookId);
      _name = notebook.title;
      _labelId = notebook.labelId;
      //_list = notebook.notesList;
    }
  }

  void _save() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoadingSave = true;
    });

    if (widget.notebookId != null) {
      final notebook = Notebook(
        id: widget.notebookId,
        title: _name,
        labelId: _labelId,
      );
      try {
        await Provider.of<Notebooks>(context, listen: false)
            .updateNotebook(notebook);
      } catch (error) {}
    } else {
      final notebook = Notebook(
        id: DateTime.now().toString(),
        title: _name,
        labelId: _labelId,
        //date: DateTime.now(),
      );
      await Provider.of<Notebooks>(context, listen: false)
          .addNotebook(notebook);
      Navigator.pop(context);
    }

    setState(() {
      _isLoadingSave = false;
    });
  }

  void _delete() async {
    setState(() {
      _isLoadingDelete = true;
    });
    try {
      await Provider.of<Notes>(context, listen: false)
          .deleteNotesByNotebookId(widget.notebookId);
      await Provider.of<Notebooks>(context, listen: false)
          .deleteNotebook(widget.notebookId);

//      Navigator.pop(context);
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);

    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (widget.notebookId != null)
                        ? 'Edit Notebook'
                        : 'Add New Notebook',
                    textScaleFactor: 1.0,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
                    initialValue: _name,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Notebook name can\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value.trim();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name', hintText: 'Enter Notebook name'),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Cover Color',
                    textScaleFactor: 1.0,
                    style: kLabelTextStyle,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    height: size.height * 0.18,
                    child: GridView.builder(
                      itemCount: kLabelColorMap.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _labelId = '${i + 1}';
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: kLabelColorMap['${i + 1}'],
                            radius: size.height * 0.02,
                            child: (_labelId == '${i + 1}')
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 2 / 1.5,
                          crossAxisSpacing: 10.0),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      if (widget.notebookId != null)
                        (_isLoadingDelete)
                            ? SpinKitPulse(
                                color: Theme.of(context).errorColor,
                              )
                            : FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: size.width * 0.06),
                                color: Theme.of(context).errorColor,
                                onPressed: () async {
                                  final response = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            title: Text(
                                              'Delete Notebook',
                                              textScaleFactor: 1.0,
                                            ),
                                            content: Text(
                                              'All notes of this notebook will be deleted, are you sure you want to delete?',
                                              textScaleFactor: 1.0,
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'Cancel',
                                                  textScaleFactor: 1.0,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'Yes',
                                                  textScaleFactor: 1.0,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              ),
                                            ],
                                          ));
                                  if (response) {
                                    _delete();
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  'Delete',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      (_isLoadingSave)
                          ? SpinKitThreeBounce(
                              color: Theme.of(context).primaryColor,
                            )
                          : FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: size.width * 0.06),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                _save();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                (widget.notebookId != null)
                                    ? 'Update'
                                    : 'Add Notebook',
                                textScaleFactor: 1.0,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
