import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:frontend/src/mvp_notes/api/note_description_resp.dart';
import 'package:frontend/src/mvp_notes/api/note_dto.dart';
import 'package:frontend/src/mvp_notes/api/notes_list_resp.dart';

export 'package:frontend/src/mvp_notes/api/note_dto.dart';
export 'package:frontend/src/mvp_notes/api/notes_list_resp.dart';
export 'package:frontend/src/mvp_notes/api/note_description_resp.dart';


class NotesApi {
  Future<NotesListResp> getNotes() async {
    final resp = await html.HttpRequest.request('/api/notes/list');
    final rawList = json.decode(resp.responseText) as Iterable<dynamic>;
    final list = rawList.map((m) => new NoteDto(m['id'], m['title'], ''));

    return new NotesListResp(list, 0);
  }

  Future<NoteDescriptionResp> loadNote(int id) async {
    final resp = await html.HttpRequest.request('/api/notes/${id}');
    final rawData = json.decode(resp.responseText) as Map<String, Object>;
    return new NoteDescriptionResp(rawData['content']);
  }

  Future<void> updateNote(int id, String title, String body) async {
    final completer = new Completer<String>();
    final req = new html.HttpRequest();

    req.onReadyStateChange.listen((e) {
      if (req.readyState == html.HttpRequest.DONE) {
        if(req.status == 200 || req.status == 0) {
          completer.complete(req.responseText);
        } else {
          completer.completeError(req.response);
        }
      }
    });

    req.open('POST', '/api/notes/update');
    req.setRequestHeader('Content-Type', 'application/json');

    final data = <String, Object> {
      'id': id, 'title': title, 'content': body
    };
    final str = json.encode(data);
    req.send(str);

    await completer.future;

    return null;
  }

  Future<NoteDto> create(String title, String body) async {
    final completer = new Completer<String>();
    final req = new html.HttpRequest();

    req.onReadyStateChange.listen((e) {
      if (req.readyState == html.HttpRequest.DONE) {
        if(req.status == 200 || req.status == 0) {
          completer.complete(req.responseText);
        } else {
          completer.completeError(req.response);
        }
      }
    });

    req.open('PUT', '/api/notes/create');
    req.setRequestHeader('Content-Type', 'application/json');

    final data = <String, Object> {
      'title': title, 'content': body
    };
    final str = json.encode(data);
    req.send(str);

    final respStr = await completer.future;
    final respData = json.decode(respStr);

    return new NoteDto(respData['id'], respData['title'], respData['content']);
  }

  Future<void> delete(int id) async {
    print('Record deleted');
    return;
  }
}