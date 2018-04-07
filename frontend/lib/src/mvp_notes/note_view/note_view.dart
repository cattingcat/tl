import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/mvp_notes/note_view/note_view_model.dart';
import 'package:frontend/src/text_editor/text_editor.dart';

export 'package:frontend/src/mvp_notes/note_view/note_view_model.dart';

@Component(
    selector: 'note-view',
    styleUrls: const <String>['note_view.css'],
    templateUrl: 'note_view.html',
    directives: const <Object>[
      NgIf,

      TextEditorComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class NoteViewComponent {
  final _changeCtrl = new StreamController<NoteViewModel>(sync: true);

  @Input() bool readonly = false;
  @Input() NoteViewModel model;

  @Output() Stream<NoteViewModel> get change => _changeCtrl.stream;

  @ViewChild('titleInput')
  html.InputElement input;

  void noteTextChanged(String newText) {
    final newModel = new NoteViewModel(model.id, model.title, newText);
    _changeCtrl.add(newModel);
  }
}