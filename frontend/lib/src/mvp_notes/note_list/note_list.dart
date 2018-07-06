import 'dart:async';

import 'package:angular/angular.dart';
import 'package:frontend/src/mvp_notes/note_list/note_card/note_card.dart';
import 'package:frontend/src/mvp_notes/note_list/note_model.dart';

export 'package:frontend/src/mvp_notes/note_list/note_model.dart';


@Component(
    selector: 'note-list',
    styleUrls: const <String>['note_list.css'],
    templateUrl: 'note_list.html',
    directives: const <Object>[
      NgFor,

      NoteCardComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class NoteListComponent {
  final _cardClickCtrl = new StreamController<NoteModel>(sync: true);
  final _cardDeleteClickCtrl = new StreamController<NoteModel>(sync: true);

  @Input() Iterable<NoteModel> notes;
  @Input() NoteModel selected;

  @Output() Stream<NoteModel> get cardClick => _cardClickCtrl.stream;
  @Output() Stream<NoteModel> get cardDeleteClick => _cardDeleteClickCtrl.stream;

  Iterable<NoteModel> get viewportNotes => notes;


  void onCardClick(NoteModel model) => _cardClickCtrl.add(model);

  void onCardDeleteClick(NoteModel model) => _cardDeleteClickCtrl.add(model);
}