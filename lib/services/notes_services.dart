import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:people_account/models/api_response.dart';
import 'package:people_account/models/note_for_listing.dart';
import 'package:people_account/models/note.dart';
import 'package:people_account/models/note_insert.dart';

class NotesService {
  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {
    'apiKey': 'b2c6478b-db26-4d04-8611-2702f3cc4ebf',
    'content-type': 'application/json',
  };

  Future<APIResponse<List<NoteList>>> getNotesList() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteList>[];
        for (var item in jsonData) {
          notes.add(NoteList.fromJson(item));
        }
        return APIResponse<List<NoteList>>(
          data: notes,
        );
      }
      return APIResponse<List<NoteList>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<NoteList>>(
        error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Note>> getNote(String noteId) {
    return http.get(API + '/notes/' + noteId, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<Note>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http
        .post(API + '/notes',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> updateNote(String noteId, NoteManipulation item) {
    return http
        .put(API + '/notes/' + noteId,
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deleteNote(String noteId) {
    return http.delete(API + '/notes/' + noteId, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
}
