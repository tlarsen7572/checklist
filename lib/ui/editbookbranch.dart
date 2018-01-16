import 'dart:async';

import 'package:checklist/src/bookio.dart';
import 'package:checklist/src/checklist.dart';
import 'package:checklist/ui/draggablelistviewitem.dart';
import 'package:checklist/ui/strings.dart';
import 'package:commandlist/commandlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checklist/src/parsepath.dart';
import 'package:checklist/src/book.dart';

class EditBookBranch extends StatefulWidget {
  final String path;

  EditBookBranch(this.path);

  createState() => new _EditBookBranchState();
}

class _EditBookBranchState extends State<EditBookBranch> {
  TextEditingController _listNameController;
  InputDecoration _listNameDecoration;
  bool _isLoading = true;
  String _listType;
  Book _book;
  CommandList<Checklist> _lists;
  BookIo _io = new BookIo();

  initState() {
    super.initState();
    _listNameDecoration = _defaultListNameDecoration();
    _listNameController = new TextEditingController();

    ParsePath.parseBook(widget.path).then((Book parsedBook) {
      setState(() {
        _book = parsedBook;
        List<String> elements = widget.path.split('/');
        _listType = elements[elements.length - 1];
        if (_listType == 'normal')
          _lists = parsedBook.normalLists;
        else
          _lists = parsedBook.emergencyLists;
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Strings.editLists(_listType)),
      ),
      body: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
    if (_isLoading)
      return new Center(
        child: new CupertinoActivityIndicator(),
      );
    else
      return new Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder(
              itemCount: _lists.length,
              itemBuilder: (_, int index) => _checklistToWidget(index),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
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
                  onPressed: null,
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
    var list = new Checklist(listName);
    var command = _lists.insert(list);
    _io.persistBook(_book).then((bool result) {
      setState(() {
        if (result) {
          _listNameDecoration = new InputDecoration(
            hintText: Strings.nameHint,
          );
          _listNameController.text = "";
        } else {
          command.undo();
          _listNameDecoration = new InputDecoration(
            hintText: Strings.nameHint,
            errorText: Strings.createListFailed,
          );
        }
      });
    });
  }

  Widget _checklistToWidget(int index) {
    var list = _lists[index];
    var size = MediaQuery.of(context).size;
    const height = 30.0;
    var editPath = widget.path + "/" + list.id;

    var newWidget = new DraggableListViewItem(
      index: index,
      moveItem: (int oldIndex){
        if (oldIndex < index) index--;
        var command = _lists.moveItem(oldIndex, index);
        _io.persistBook(_book).then((success){
          if (success)
            setState((){});
          else
            command.undo();
        });
      },
      child: new Container(
            width: size.width,
            height: height,
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Text(list.name),
                ),
                new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: null,
                ),
                new IconButton(
                    icon: new Icon(Icons.edit),
                  onPressed: (){
                      print(editPath);
                      Navigator.of(context).pushNamed(editPath);
                  },
                ),
              ],
            ),
          ),
    );

    return newWidget;
  }
}
