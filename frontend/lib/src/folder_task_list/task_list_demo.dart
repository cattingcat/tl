import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/core_components/dnd/dnd.dart';
import 'package:frontend/src/floating_creation_form/floating_creation_form.dart';
import 'package:frontend/src/task_list/card_components/mouse_card_event.dart';
import 'package:frontend/src/task_list/card_components/dnd_events.dart';
import 'package:frontend/src/task_list/highlight_options.dart';
import 'package:frontend/src/task_list/models/model_tree_manager/model_tree_manager.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/task_model.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view_impl.dart';
import 'package:frontend/src/task_list/task_list_component/events/list_mouse_card_event.dart';
import 'package:frontend/src/task_list/task_list_component/task_list_component.dart';
import 'package:frontend/src/task_list/card_type.dart';

@Component(
    selector: 'task-list-demo',
    templateUrl: 'task_list_demo.html',
    styleUrls: const <String>['task_list_demo.css'],
    directives: const <Object>[
      TaskListComponent,
      FloatingCreationFormComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListDemo {
  ModelTreeManager _treeManager;

  TreeView treeView;
  CardType cardType;
  HighlightOptions highlightOptions;

  FormPosition creationFormPos;
  TaskListModel _anchorModel;
  _AnchorPosition _anchorPosition;


  TaskListDemo() {
    final tree = new LinkedTree<TaskListModel>();
    for(int i = 0; i < 70; ++i) {
      final task = new TaskModel('$i');
      task.isExpanded = true;

//      for(int j = 0; j < 5; ++j) {
//        final subTask = new TaskModel('$i ; $j');
//        task.addChild(subTask);
//      }

      tree.addFirst(task);
    }
    _treeManager = new ModelTreeManager(tree);

    treeView = _treeManager.getTreeView();
    cardType = CardType.Default;
  }

  void changeDataSource() { }

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

    final dropped = Dnd.dataTransfer as TaskListModel;
    dropped.unlink();

    event.model.addChild(dropped);

    if(highlightOptions.model == event.model) {
      highlightOptions = const HighlightOptions.none();
    }

    _updateList();
  }

  void onClick(MouseCardEvent event) {
    print('clicked: ${event.model}');
  }

  void onCardMouseOver(ListMouseCardEvent event) {
    final mouseOffset = event.nativeEvent.offset;
    final cardH = cardType.getHeight(event.model);

    _anchorModel = event.model;
    if(mouseOffset.y > cardH / 2) {
      final top = event.listOffset.y + cardH - 10;
      creationFormPos = new FormPosition(event.nativeElement, top, -30);
      _anchorPosition = _AnchorPosition.After;
    } else {
      final top = event.listOffset.y - 10;
      creationFormPos = new FormPosition(event.nativeElement, top, -30);
      _anchorPosition = _AnchorPosition.Before;
    }
  }

  void listMouseLeave(html.MouseEvent event) {
    creationFormPos = null;
  }

  void handleCreationSubmit(String event) {
    print('hey $event');
    final model = new TaskModel(event);

    if(_anchorPosition == _AnchorPosition.After) {
      _anchorModel.insertAfter(model);
    } else {
      _anchorModel.insertBefore(model);
    }

    _updateList();
  }


  void _updateList() {
    (treeView as TreeViewImpl).update();
  }
}

enum _AnchorPosition {Before, After}