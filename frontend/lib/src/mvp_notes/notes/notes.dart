import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/loading/loading.dart';
import 'package:frontend/src/mvp_notes/api/notes_api.dart';
import 'package:frontend/src/mvp_notes/note_creation_form/note_creation_form.dart';
import 'package:frontend/src/mvp_notes/note_list/note_list.dart';
import 'package:frontend/src/mvp_notes/note_view/note_view.dart';

@Component(
  selector: 'notes',
  styleUrls: const <String>['notes.css'],
  templateUrl: 'notes.html',
  directives: const <Object>[
    NgIf,
    LoadingComponent,

    NoteListComponent,

    NoteViewComponent,
    NoteCreationFormComponent
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
  NoteViewModel noteView;


  void onCreateClick() {
    selected = null;
    viewState = NotesViewState.Creating;
  }

  void onCardClick(NoteModel model) {
    selected = model;
    viewState = NotesViewState.Loading;
    _api.loadNote(model.id).then(_onViewDataReady);
  }

  void onNoteChange(NoteViewModel model) {
    _api.updateNote(model.id, model.title, model.body);
  }

  void onNoteCreate(NoteCreationModel model) async {
    final dto = await _api.create(model.title, model.body);
    notes = notes.toList()..insert(0, new NoteModel(dto.id, dto.title));

    viewState = NotesViewState.Zero;
  }


  @override
  void ngOnInit() {
    state = NotesAppState.Loading;
    _api.getNotes().then(_onDataReady);
  }


  void _onDataReady(NotesListResp data) {
    final noteList = data.notes.map((i) => new NoteModel(i.id, i.title)).toList();
    notes = noteList;

    state = NotesAppState.Loaded;

    if(noteList.isEmpty) viewState = NotesViewState.Creating;

    // TODO: Why should we call detect changes manually???
    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  void _onViewDataReady(NoteDescriptionResp data) {
    noteView = new NoteViewModel(selected.id, selected.title, data.text);
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
  Zero, Loading, Loaded, Creating
}