import 'dart:async';
import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/directives/hover_hooks.dart';
import 'package:frontend/src/core_components/editable_text/editable_text.dart';
import 'package:frontend/src/core_components/editable_text/text_model.dart';
import 'package:frontend/src/task_list/card_components/task_card_observer.dart';
import 'package:frontend/src/task_list/card_components/title_change_card_event.dart';
import 'package:frontend/src/task_list/card_components/toggle_card_event.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';

@Component(
  selector: 'narrow-task-card',
  styleUrls: const <String>['narrow_task_card.css'],
  templateUrl: 'narrow_task_card.html',
  directives: const <Object>[
    HoverHooks,
    EditableTextComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class NarrowTaskCard implements AfterViewInit, OnChanges {
  @Input() TaskListViewModel model;
  @Input() TaskCardObserver observer;

  TitleModel titleModel;


  void onTitleChange(String title) {
    Zone.ROOT.run(() {
      final event = new TitleChangeCardEvent(model.model, title);
      observer.titleChange(event);
    });
  }

  void onExpanderClick() {
    Zone.ROOT.run(() {
      final event = new ToggleCardEvent(model.model, !model.model.isExpanded);
      observer.toggle(event);
    });
  }


  @override
  void ngAfterViewInit() {}

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    titleModel = new TitleModel(model.toString());
  }
}