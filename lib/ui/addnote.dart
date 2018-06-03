import 'dart:async';
import 'dart:collection';

import 'package:checklist/src/note.dart';
import 'package:checklist/ui/strings.dart';
import 'package:checklist/ui/templates.dart';
import 'package:flutter/material.dart';

Future<Note> addNote(BuildContext context, HashSet<Note> existingNotes) async {
  return await showDialog<Note>(
    context: context,
    builder: (context) => AddNote(existingNotes: existingNotes),
  );
}

class AddNote extends StatefulWidget {
  AddNote({this.existingNotes});

  final HashSet<Note> existingNotes;

  createState() => new _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  Priority selectedPriority = Priority.Note;
  var controller = new TextEditingController();
  var decoration = new InputDecoration();

  InputDecoration defaultDecoration() => new InputDecoration();
  InputDecoration errorDecoration() =>
      new InputDecoration(errorText: Strings.noNoteTextError);

  Widget Function(BuildContext, int) _getBuilder(HashSet<Note> existingNotes) {
    return (BuildContext context, int index) {
      var note = existingNotes.elementAt(index);
      return themeRaisedButton(
        onPressed: () => Navigator.of(context).pop(note),
        child: ListItem2TextRows(
          line1: note.text,
          line2: Strings.priorityToString(note.priority),
        ),
      );
    };
  }

  void _addNote() {
    if (controller.text == '') {
      setState(() => decoration = errorDecoration());
      return;
    }

    var note = new Note(selectedPriority, controller.text);
    Navigator.of(context).pop(note);
  }

  Widget build(BuildContext context) {
    return ThemeDialog(
      child: Column(
        children: <Widget>[
          editorElementPadding(child: Text(Strings.existingNotes)),
          Expanded(
            child: ListView.builder(
              itemExtent: 72.0,
              itemCount: widget.existingNotes.length,
              itemBuilder: _getBuilder(widget.existingNotes),
            ),
          ),
          Padding(
            padding: defaultLRB,
            child: Column(
              children: <Widget>[
                editorElementPadding(
                  child: Text(Strings.createNote),
                ),
                TextField(
                  controller: controller,
                  decoration: decoration,
                  maxLines: 3,
                  maxLength: maxNoteLen,
                  keyboardType: TextInputType.text,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<Priority>(
                        value: selectedPriority,
                        items: getPriorities(),
                        onChanged: (selection) =>
                            setState(() => selectedPriority = selection),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addNote,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
