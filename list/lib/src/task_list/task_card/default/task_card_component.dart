import 'dart:async';
import 'package:angular/angular.dart';
import 'package:list/src/core_components/directives/hover_hooks.dart';
import 'package:list/src/core_components/editable_title/editable_text.dart';
import 'package:list/src/core_components/editable_title/text_model.dart';
import 'package:list/src/task_list/task_card/title_change_card_event.dart';
import 'package:list/src/task_list/task_card/toggle_card_event.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

@Component(
  selector: 'task-card',
  styleUrls: const <String>['task_card_component.scss.css'],
  templateUrl: 'task_card_component.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    HoverHooks,
    EditableText
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskCardComponent implements AfterViewInit, OnChanges {
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
    titleModel = new TitleModel(model.text);
  }
}