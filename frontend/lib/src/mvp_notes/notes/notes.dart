import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:frontend/src/core_components/loading/loading.dart';
import 'package:frontend/src/mvp_notes/api/notes_api.dart';
import 'package:frontend/src/mvp_notes/note_creation_form/note_creation_form.dart';
import 'package:frontend/src/mvp_notes/note_list/note_list.dart';
import 'package:frontend/src/mvp_notes/note_view/note_view.dart';
import 'package:frontend/src/routes/routes.dart';

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
  final Router _router;
  final Location _location;

  NotesComponent(this._cdr, this._api, this._location, this._router);

  NotesAppState state = NotesAppState.loading;
  NotesViewState viewState = NotesViewState.zero;
  Iterable<NoteModel> notes = const Iterable<NoteModel>.empty();
  NoteModel selected;
  NoteViewModel noteView;


  void onCreateClick() {
    selected = null;
    viewState = NotesViewState.creating;
  }

  void onCardClick(NoteModel model) {
    if(selected == model) return;

    selected = model;
    viewState = NotesViewState.loading;
    _api.loadNote(model.id).then(_onViewDataReady);


    final newUri = Routes.notesIdPath.toUrl(parameters: <String, String>{'id': model.id.toString()});
    _location.go(newUri);
  }

  void onCardDeleteClick(NoteModel model) {
    notes = notes.where((i) => i != model).toList();
    if(noteView.id == model.id) {
      viewState = NotesViewState.zero;
      noteView = null;
    }

    if(selected.id == model.id) {
      selected = null;
    }

    _api.delete(model.id);
  }

  void onNoteChange(NoteViewModel model) {
    _api.updateNote(model.id, model.title, model.content);

    final newList = notes.toList();
    final modelIndex = newList.indexWhere((i) => i.id == model.id);
    final newModel = new NoteModel(model.id, model.title);
    newList.replaceRange(modelIndex, modelIndex + 1, [newModel]);

    notes = newList;
    if(selected.id == newModel.id) selected = newModel;
  }

  void onNoteCreate(NoteCreationModel model) async {
    final dto = await _api.create(model.title, model.body);
    notes = notes.toList()..insert(0, new NoteModel(dto.id, dto.title));

    viewState = NotesViewState.zero;
  }


  @override
  void ngOnInit() {
    state = NotesAppState.loading;
    _api.getNotes().then(_onDataReady);
  }


  void _onDataReady(NotesListResp data) {
    final noteList = data.notes.map((i) => new NoteModel(i.id, i.title)).toList();
    notes = noteList;

    final noteId = _router.current.parameters['id'];
    if(noteId != null) {
      final id = int.tryParse(noteId) ?? -1;

      if (id != -1) {
        final uriNote = notes.firstWhere((i) => i.id == id, orElse: () => null);
        onCardClick(uriNote);
      }

      if(selected == null) {
        print('Unknown id');
      }
    }

    state = NotesAppState.loaded;

    if(noteList.isEmpty) viewState = NotesViewState.creating;

    // TODO: Why should we call detect changes manually???
    _cdr
      ..markForCheck()
      ..detectChanges();
  }

  void _onViewDataReady(NoteDescriptionResp data) {
    noteView = new NoteViewModel(selected.id, selected.title, data.text);
    viewState = NotesViewState.loaded;

    // TODO: Why should we call detect changes manually???
    _cdr
      ..markForCheck()
      ..detectChanges();
  }
}

enum NotesAppState {
  loading, loaded
}

enum NotesViewState {
  zero, loading, loaded, creating
}