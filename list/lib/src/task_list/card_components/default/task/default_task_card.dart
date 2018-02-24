import 'dart:async';
import 'package:angular/angular.dart';
import 'package:list/src/core_components/directives/hover_hooks.dart';
import 'package:list/src/core_components/editable_text/editable_text.dart';
import 'package:list/src/core_components/editable_text/text_model.dart';
import 'package:list/src/task_list/card_components/task_card_observer.dart';
import 'package:list/src/task_list/card_components/title_change_card_event.dart';
import 'package:list/src/task_list/card_components/toggle_card_event.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

@Component(
  selector: 'default-task-card',
  styleUrls: const <String>['default_task_card.css'],
  templateUrl: 'default_task_card.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    HoverHooks,
    EditableText
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class DefaultTaskCard implements AfterViewInit, OnChanges {
  @Input() TaskListViewModel model;
  @Input() TaskCardObserver observer;

  TitleModel titleModel;


  void onTitleChange(String title) {
    final event = new TitleChangeCardEvent(model.model, title);
    observer.titleChange(event);
  }

  void onExpanderClick() {
    final event = new ToggleCardEvent(model.model, !model.model.isExpanded);
    observer.toggle(event);
  }



  @override
  void ngAfterViewInit() {}

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    titleModel = new TitleModel(model.toString());
  }
}