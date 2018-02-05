import 'dart:async';
import 'package:angular/angular.dart';
import 'package:list/src/core_components/directives/hover_hooks.dart';
import 'package:list/src/core_components/editable_text/editable_text.dart';
import 'package:list/src/core_components/editable_text/text_model.dart';
import 'package:list/src/task_list/card_components/title_change_card_event.dart';
import 'package:list/src/task_list/card_components/toggle_card_event.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

@Component(
  selector: 'default-task-card',
  styleUrls: const <String>['default_task_card.scss.css'],
  templateUrl: 'default_task_card.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    HoverHooks,
    EditableText
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class DefaultTaskCard implements AfterViewInit, OnChanges {
  final _toggleCtrl = new StreamController<ToggleCardEvent>(sync: true);
  final _titleChangeCtrl = new StreamController<TitleChangeCardEvent>(sync: true);

  @Input() TaskListViewModel model;

  @Output() Stream<ToggleCardEvent> get toggle => _toggleCtrl.stream;
  @Output() Stream<TitleChangeCardEvent> get titleChange => _titleChangeCtrl.stream;

  TitleModel titleModel;


  void onTitleChange(String title) {
    final event = new TitleChangeCardEvent(model.model, title);
    _titleChangeCtrl.add(event);
  }

  void onExpanderClick() {
    // TODO: make correct expand-collapse state
    final event = new ToggleCardEvent(model.model, true);
    _toggleCtrl.add(event);
  }



  @override
  void ngAfterViewInit() {}

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    titleModel = new TitleModel(model.toString());
  }
}