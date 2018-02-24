import 'dart:async';

import 'package:checklist/src/bookio.dart';
import 'package:checklist/src/checklist.dart';
import 'package:checklist/ui/editorpage.dart';
import 'package:checklist/ui/templates.dart';
import 'package:draggablelistview/draggablelistview.dart';
import 'package:checklist/ui/listviewpopupmenubutton.dart';
import 'package:checklist/ui/strings.dart';
import 'package:commandlist/commandlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checklist/src/parsepath.dart';
import 'package:checklist/src/book.dart';

class EditBookBranch extends EditorPage {
  EditBookBranch(String path, ThemeChangeCallback onThemeChanged)
      : super(path, onThemeChanged, const EdgeInsets.all(0.0));

  createState() => new _EditBookBranchState();
}

class _EditBookBranchState extends EditorPageState {
  TextEditingController _listNameController;
  InputDecoration _listNameDecoration;
  String _listType;
  CommandList<Checklist> _lists;

  initState() {
    super.initState();

    var result = ParsePath.validate(widget.path);
    switch (result) {
      case ParseResult.NormalLists:
        _listType = 'normal';
        break;
      case ParseResult.EmergencyLists:
        _listType = 'emergency';
        break;
      default:
        break;
    }

    initEditorState((result) {
      _listNameDecoration = _defaultListNameDecoration();
      _listNameController = new TextEditingController();

      switch (result.result) {
        case ParseResult.NormalLists:
          _lists = book.normalLists;
          break;
        case ParseResult.EmergencyLists:
          _lists = book.emergencyLists;
          break;
        default:
          break;
      }
    });
  }

  Widget build(BuildContext context) {
    return buildPage(
      context: context,
      title: Strings.editLists(_listType),
      bodyBuilder: _getBody,
    );
  }

  Widget _getBody(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: new DraggableListView<Checklist>(
            rowHeight: 48.0,
            source: _lists,
            builder: _checklistToWidget,
            onMove: buildOnMove(_lists),
          ),
        ),
        new Padding(
          padding: defaultLRB,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  onSubmitted: _createChecklist,
                  controller: _listNameController,
                  decoration: _listNameDecoration,
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.add),
                onPressed: _pressCreate,
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _defaultListNameDecoration() {
    return new InputDecoration(hintText: Strings.nameHint);
  }

  void _createChecklist(String listName) {
    if (listName == ''){
      setState(_noNameProvided);
      return;
    }

    var list = new Checklist(name: listName);
    var command = _lists.insert(list);
    io.persistBook(book).then((bool result) {
      setState(() {
        if (result) {
          _resetTextfield();
        } else {
          command.undo();
          _errorCreating();
        }
      });
    });
  }

  _noNameProvided(){
    _listNameDecoration = new InputDecoration(
      hintText: Strings.nameHint,
      errorText: Strings.noNameError,
    );
  }

  _resetTextfield(){
    _listNameDecoration = new InputDecoration(
      hintText: Strings.nameHint,
    );
    _listNameController.text = "";
  }

  _errorCreating(){
    _listNameDecoration = new InputDecoration(
      hintText: Strings.nameHint,
      errorText: Strings.createListFailed,
    );
  }

  void _pressCreate(){
    _createChecklist(_listNameController.text);
  }

  Widget _checklistToWidget(Checklist list) {
    var editPath = widget.path + "/" + list.id;

    return new ListViewPopupMenuButton(
      editAction: () => Navigator.of(context).pushNamed(editPath),
      deleteAction: () async {
        var command = _lists.remove(list);
        var success = await io.persistBook(book);
        if (!success)
          command.undo();
        else
          setState(() {});
      },
      child: new Container(
        height: 48.0,
        child: new Padding(
          padding: new EdgeInsets.only(left: 16.0),
          child: new Align(
            alignment: new Alignment(-1.0, 0.0),
            child: new Text(
              list.name,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
