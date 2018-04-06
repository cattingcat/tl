import 'dart:async';

import 'package:angular/angular.dart';
import 'package:frontend/src/mvp_notes/note_list/note_model.dart';


@Component(
  selector: 'note-card',
  styleUrls: const <String>['note_card.css'],
  templateUrl: 'note_card.html',
  directives: const <Object>[],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class NoteCardComponent {
  final _clickCtrl = new StreamController<NoteModel>(sync: true);

  @Input() NoteModel model;


  @Output() Stream<NoteModel> get cardClick => _clickCtrl.stream;

  @HostListener('click')
  void onClick() => _clickCtrl.add(model);

  @HostListener('mouseenter')
  void onMouseEnter() {}

  @HostListener('mouseleave')
  void onMouseLeave() {}
}