import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/loading/loading.dart';
import 'package:frontend/src/mvp_notes/api/notes_api.dart';
import 'package:frontend/src/mvp_notes/note_list/note_list.dart';
import 'package:frontend/src/text_editor/text_editor.dart';

@Component(
  selector: 'notes',
  styleUrls: const <String>['notes.css'],
  templateUrl: 'notes.html',
  directives: const <Object>[
    NgIf,
    LoadingComponent,

    NoteListComponent,

    TextEditorComponent
  ],
  exports: const <Object>[NotesAppState, NotesViewState],
  changeDetection: ChangeDetectionStrategy.Default,
  providers: const [
    NotesApi
  ]
)
class NotesComponent implements OnInit {
  final ChangeDetectorRef _cdr;
  final NotesApi _api;

  NotesComponent(this._cdr, this._api);

  NotesAppState state = NotesAppState.Loading;
  NotesViewState viewState = NotesViewState.Zero;
  Iterable<NoteModel> notes;
  NoteModel selected;
  String viewText;


  void onCardClick(NoteModel model) {
    selected = model;
    viewState = NotesViewState.Loading;
    _api.loadNote(model.id).then(_onViewDataReady);
  }

  void noteTextChanged(String newContent) {
    _api.updateNote(selected.id, newContent);
  }


  @override
  void ngOnInit() {
    state = NotesAppState.Loading;
    _api.getNotes().then(_onDataReady);
  }


  void _onDataReady(NotesListResp data) {
    notes = data.notes.map((i) => new NoteModel(i.id, i.title)).toList();

    state = NotesAppState.Loaded;

    // TODO: Why should we call detect changes manually???
    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  void _onViewDataReady(NoteDescriptionResp data) {
    viewText = data.text;
    viewState = NotesViewState.Loaded;

    // TODO: Why should we call detect changes manually???
    _cdr.markForCheck();
    _cdr.detectChanges();
  }
}

enum NotesAppState {
  Loading, Loaded
}

enum NotesViewState {
  Zero, Loading, Loaded
}