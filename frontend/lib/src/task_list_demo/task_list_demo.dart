import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/card_components/click_card_event.dart';
import 'package:frontend/src/task_list/card_components/default/task/default_task_card.dart';
import 'package:frontend/src/task_list/card_components/dnd_events.dart';
import 'package:frontend/src/task_list/highlight_options.dart';
import 'package:frontend/src/task_list/models/model_tree_manager/model_tree_manager.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/task_model.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list/task_list_component/task_list_component.dart';
import 'package:frontend/src/task_list/card_type.dart';
import 'package:frontend/src/task_list_demo/test_component/test_component.dart';

@Component(
    selector: 'task-list-demo',
    templateUrl: 'task_list_demo.html',
    styleUrls: const <String>['task_list_demo.css'],
    directives: const <Object>[
      DefaultTaskCard,
      TaskListComponent,

      TestComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListDemo {
  ModelTreeManager _treeManager;

  TreeView treeView;
  CardType cardType;
  HighlightOptions highlightOptions;

  TaskListDemo() {
    final tree = new LinkedTree<TaskListModelBase>();
    for(int i = 0; i < 50; ++i) {
      final task = new TaskModel('$i');
      task.isExpanded = true;

      for(int j = 0; j < 5; ++j) {
        final subTask = new TaskModel('$i ; $j');
        task.addChild(subTask);
      }

      tree.addFirst(task);
    }
    _treeManager = new ModelTreeManager(tree);

    treeView = _treeManager.getTreeView();
    cardType = CardType.Default;
  }

  void changeDataSource() {
//    final list = new List<TaskListViewModel>();
//    for(var i = 0; i < 100; ++i) {
//      list.add(new TaskListViewModel('!!!: $i'));
//    }
//
//    dataSource = new InMemoryViewModelDataSource(list);
  }

  void changeCardType() {
    if(cardType == CardType.Default) {
      cardType = CardType.Narrow;
    } else {
      cardType = CardType.Default;
    }
  }

  void onDragOver(DndEvent event) {
    final element = event.nativeEvent.target as html.Element;
    final yPos = event.nativeEvent.offset.y;

    if(yPos < element.clientHeight * 0.3) {
      highlightOptions = new HighlightOptions(event.model, HighlightPosition.Before);
    } else if(yPos > element.clientHeight * 0.7) {
      highlightOptions = new HighlightOptions(event.model, HighlightPosition.After);
    } else {
      highlightOptions = new HighlightOptions(event.model, HighlightPosition.Center);
    }
  }
  void onDragEnter(DndEvent event) {
    print('dragEnter ${event.model}');
  }
  void onDragLeave(DndEvent event) {
    print('dragLeave ${event.model}');

    if(highlightOptions.model == event.model) {
      highlightOptions = const HighlightOptions.none();
    }
  }
  void onDrop(DndEvent event) {
    print('drop ${event.model}');

    if(highlightOptions.model == event.model) {
      highlightOptions = const HighlightOptions.none();
    }
  }

  void onClick(ClickCardEvent event) {
    print('clicked: ${event.model}');
  }
}