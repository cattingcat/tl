import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:list/src/core_components/dnd/draggable.dart';
import 'package:list/src/core_components/dnd/drop_target.dart';
import 'package:list/src/core_components/dnd/drop_target_observer.dart';
import 'package:list/src/task_list/card_components/default/task/default_task_card.dart';
import 'package:list/src/task_list/card_components/dnd_events.dart';
import 'package:list/src/task_list/card_components/narrow/task/narrow_task_card.dart';
import 'package:list/src/task_list/card_components/task_card_observer.dart';
import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/highlight_options.dart';
import 'package:list/src/task_list/view_models/sublist_view_model.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';


@Component(
    selector: 'sublist',
    styleUrls: const <String>['sublist_component.css'],
    templateUrl: 'sublist_component.html',
    directives: const <Object>[
      NgFor,
      NgIf,
      DefaultTaskCard,
      NarrowTaskCard,
      SublistComponent,
      Draggable,
      DropTarget
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class SublistComponent implements DropTargetObserver {
  @Input() SublistViewModel model;
  @Input() CardType cardType;
  @Input() TaskCardObserver observer;
  @Input() HighlightOptions highlight;


  bool get showHeader => model.showHeader && model.headerModel != null;

  bool get showSublist => model.showSublist && model.sublist != null && model.sublist.isNotEmpty;


  bool get isDefaultCard => cardType == CardType.Default;

  bool get isNarrowCard => cardType == CardType.Narrow;


  bool get highlightBefore => _hlThis && highlight.position == HighlightPosition.Before;

  bool get highlightAfter => _hlThis && highlight.position == HighlightPosition.After;

  bool get highlightCenter => _hlThis && highlight.position == HighlightPosition.Center;

  bool get highlightSublist => _hlThis && highlight.position == HighlightPosition.Sublist;


  DropTargetObserver get dndObserver => this;

  TaskListViewModel get headerModel => model.headerModel;


  @override
  void onDragOver(html.MouseEvent event) {
    final e = new DndEvent(model.headerModel.model, event);
    observer.onDragOver(e);
  }

  @override
  void onDragLeave(html.MouseEvent event) {
    final e = new DndEvent(model.headerModel.model, event);
    observer.onDragLeave(e);
  }

  @override
  void onDragEnter(html.MouseEvent event) {
    final e = new DndEvent(model.headerModel.model, event);
    observer.onDragEnter(e);
  }

  @override
  void onDrop(html.MouseEvent event) {
    final e = new DndEvent(model.headerModel.model, event);
    observer.onDrop(e);
  }


  bool get _hlThis => highlight != null && highlight.model == model?.headerModel?.model;
}