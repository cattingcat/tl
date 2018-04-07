import 'package:angular/angular.dart';
import 'package:frontend/src/text_editor/text_editor.dart';

export 'package:frontend/src/mvp_notes/note_view/note_view_model.dart';

@Component(
    selector: 'note-creation-form',
    styleUrls: const <String>['note_creation_form.css'],
    templateUrl: 'note_creation_form.html',
    directives: const <Object>[
      TextEditorComponent
    ],
    exports: <Type>[NoteCreationFormComponent],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class NoteCreationFormComponent {
  static const String titlePlaceholder = 'Title for new note...';
  static const String bodyPlaceholder = 'Type your note...';

  String _body = '';
  String _title = '';


  void onTextChanged(String text) {
    _body = text;
  }

  void onTitleChanged(String text) {
    _title = text;
  }

  void onCreateClick() {
    print('Create: $_title; $_body');
  }
}