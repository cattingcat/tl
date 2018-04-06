import 'package:frontend/src/mvp_notes/api/note_dto.dart';

class NotesListResp {
  final Iterable<NoteDto> notes;
  final int count;

  NotesListResp(this.notes, this.count);
}