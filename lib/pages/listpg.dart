import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:people_account/models/api_response.dart';
import 'package:people_account/models/note_for_listing.dart';
import 'package:people_account/pages/note_delete.dart';
import 'package:people_account/pages/note_modify.dart';
import 'package:people_account/services/notes_services.dart';

class CreateList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateListState();
  }
}

class _CreateListState extends State<CreateList> {
  NotesService get service => GetIt.I<NotesService>();

  APIResponse<List<NoteList>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNotesList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NoteModify()))
                .then((_) => _fetchNotes());
          },
        ),
        appBar: AppBar(
          title: Text('List Page'),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (_apiResponse.error) {
              return Center(
                child: Text(_apiResponse.errorMessage),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    key: ValueKey(_apiResponse.data[index].noteId),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      final result = await showDialog(
                          context: context, builder: (_) => NoteDelete());
                      var message;
                      if (result) {
                        final deleteResult = await service
                            .deleteNote(_apiResponse.data[index].noteId);

                        if (deleteResult != null && deleteResult.data == true) {
                          message = 'Note was deleted successfully';
                        } else {
                          message =
                              deleteResult?.errorMessage ?? 'An error occured';
                        }
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Done'),
                                  content: Text(message),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ));

                        return deleteResult?.data ?? 'false';
                      }
                      print(result);
                      return result;
                    },
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 16.0),
                      child: Align(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: ListTile(
                        title: Text(
                          _apiResponse.data[index].noteTitle,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        subtitle: Text(
                            'Last Edited on ${formatDateTime(_apiResponse.data[index].editedLastDateTime ?? _apiResponse.data[index].createDateTime)}'),
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (_) => NoteModify(
                                    noteId: _apiResponse.data[index].noteId)))
                            .then((data) => _fetchNotes())));
              },
              itemCount: _apiResponse.data.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1.0,
                  color: Colors.grey,
                );
              },
            );
          },
        ));
  }
}
