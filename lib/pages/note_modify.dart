import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:people_account/models/note.dart';
import 'package:people_account/models/note_insert.dart';
import 'package:people_account/services/notes_services.dart';

class NoteModify extends StatefulWidget {
  final String noteId;

  NoteModify({this.noteId});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteId != null;

  NotesService get notesService => GetIt.I<NotesService>();
  String errorMessage;
  Note note;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.noteId).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response.error) {
          errorMessage = response.error ?? 'An error occured';
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit node' : 'Create Node'),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(hintText: 'Note Title'),
                    ),
                    SizedBox(height: 6.0),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(hintText: 'Note Content'),
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text('Submit'),
                        onPressed: () async {
                          if (isEditing) {
                            setState(() {
                              _isLoading = true;
                            });
                            final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                            );
                            final result = await notesService.updateNote(
                                widget.noteId, note);
                            setState(() {
                              _isLoading = false;
                            });
                            final title = 'Done';
                            final text = result.error
                                ? (result.errorMessage ?? 'An error occured')
                                : 'Your note was edited';
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                            );
                            final result = await notesService.createNote(note);
                            setState(() {
                              _isLoading = false;
                            });
                            final title = 'Done';
                            final text = result.error
                                ? (result.errorMessage ?? 'An error occured')
                                : 'Your note was created';
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
        ));
  }
}
