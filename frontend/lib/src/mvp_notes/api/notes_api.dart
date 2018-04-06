import 'dart:async';

import 'package:frontend/src/mvp_notes/api/note_description_resp.dart';
import 'package:frontend/src/mvp_notes/api/note_dto.dart';
import 'package:frontend/src/mvp_notes/api/notes_list_resp.dart';

export 'package:frontend/src/mvp_notes/api/note_dto.dart';
export 'package:frontend/src/mvp_notes/api/notes_list_resp.dart';
export 'package:frontend/src/mvp_notes/api/note_description_resp.dart';

const _lorem = '''
<h3>  Lorem ipsum&nbsp;</h3><blockquote style="margin: 0 0 0 40px; border: none; padding: 0px;"><div>dolor sit amet, consectetur 
  adipiscing elit, sed&nbsp;</div></blockquote><div><br></div><div><ol><li>do eiusmod tempor 
  incididunt ut labore et&nbsp;<br></li><li>dolore magna aliqua. 
  Ut enim ad minim v<br></li></ol></div><div><ul><li>eniam, quis nostrud 
  exercitation ullamco<br></li><li>&nbsp;laboris nisi ut aliquip 
  ex ea commodo cons<br></li></ul></div><div><b>equat</b>. Duis aute <sub>irure</sub> dolor
   in <sup>reprehenderit</sup></div><div>&nbsp;in <i>voluptate</i> velit esse cillum
    dolore eu fugiat&nbsp;</div><div>nulla pariatur. <u>Excepteur</u> 
    sint <strike>occaecat</strike> cupid</div><div>atat non <font size="5">proident</font>, sunt 
    in culpa qui officia d</div><div>eserunt <font color="#008000">mollit</font> anim 
    id est <span style="background-color: yellow;">laborum</span>.
  </div>
  ''';

// TODO: [EK] Zdelat' backend
class NotesApi {
  Future<NotesListResp> getNotes() {
    return new Future.delayed(const Duration(seconds: 2), () {
      return new NotesListResp(<NoteDto>[
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr'),
        new NoteDto(0, 'Firt note', 'descr'),
        new NoteDto(0, 'Second note', 'descr'),
        new NoteDto(0, 'Third note', 'descr')
      ], 5);
    });
  }

  Future<NoteDescriptionResp> loadNote(int id) {
    return new Future.delayed(const Duration(seconds: 2), () {
      return new NoteDescriptionResp(_lorem);
    });
  }

  Future<void> updateNote(int id, String content) {
    return Future.delayed(const Duration(seconds: 2));
  }
}