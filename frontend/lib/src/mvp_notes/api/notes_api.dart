import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:frontend/src/mvp_notes/api/note_description_resp.dart';
import 'package:frontend/src/mvp_notes/api/note_dto.dart';
import 'package:frontend/src/mvp_notes/api/notes_list_resp.dart';

export 'package:frontend/src/mvp_notes/api/note_dto.dart';
export 'package:frontend/src/mvp_notes/api/notes_list_resp.dart';
export 'package:frontend/src/mvp_notes/api/note_description_resp.dart';


const String _localStorageKey = 'nts';

// TODO: [EK] Zdelat' backend
class NotesApi {
  Future<NotesListResp> getNotes() {
    final notes = _getLocalNotes();
    return new Future.delayed(const Duration(seconds: 2), () {
      return new NotesListResp(notes, 5);
    });
  }

  Future<NoteDescriptionResp> loadNote(int id) {
    final notes = _getLocalNotes();
    final note = notes.where((i) => i.id == id).first;
    return new Future.delayed(const Duration(seconds: 2), () {
      return new NoteDescriptionResp(note.content);
    });
  }

  Future<void> updateNote(int id, String title, String body) {
    final notes = _getLocalNotes();
    final noteIndex = notes.indexWhere((i) => i.id == id);
    final newNote = new NoteDto(id, title, body);
    notes[noteIndex] = newNote;

    _saveNotes(notes);

    return Future.delayed(const Duration(seconds: 2));
  }

  Future<NoteDto> create(String title, String body) async {
    final id = Random.secure().nextInt(1000000);
    final note = new NoteDto(id, title, body);

    final notes = _getLocalNotes();
    notes.insert(0, note);

    _saveNotes(notes);

    return note;
  }

  List<NoteDto> _getLocalNotes() {
    final tmp = window.localStorage[_localStorageKey] ?? '[]';
    final localNotes = json.decode(tmp) as Iterable<Map<String, Object>>;
    final notes = localNotes.map((i) => new NoteDto(i['id'] as int, i['title'], i['content'])).toList();
    return notes;
  }

  void _saveNotes(List<NoteDto> notes) {
    final newNotes = notes.map((i) => <String, Object>{'id': i.id, 'title': i.title, 'content': i.content}).toList();
    final str = json.encode(newNotes);

    window.localStorage[_localStorageKey] = str;
  }
}