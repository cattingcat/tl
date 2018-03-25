import 'dart:async';

import 'package:angular/angular.dart';
import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/card_components/task_card_observer.dart';
import 'package:frontend/src/task_list/card_type.dart';
import 'package:frontend/src/task_list/models/root_model.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/task_model.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list2/sublist/sublist.dart';


@Component(
    selector: 'task-list',
//    styleUrls: const <String>['task_list.css'],
    templateUrl: 'task_list.html',
    directives: const <Object>[
      NgIf,
      SublistComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListComponent implements OnInit {
  @Input() TreeView dataSource = new TreeViewStub();


  SublistItem rootItem;
  TaskCardObserver sublistObserver = const TaskCardObserver.stub();
  CardType cardType = CardType.Default;

  TaskListModel get root => dataSource.tree.root;

  void onTestClick() {
    final childList = root.children.toList();
    final start = [root, childList[1], childList[1].children.toList()[1]];
    final end = [root, childList[17]];
    final interval = new RenderInterval(start, end);
    rootItem = new SublistItem(root, interval);
  }

  void onTest2Click() {
    final childList = root.children.toList();

    final i = new TaskModel('test item');
    i.isExpanded = true;
    i.addChild(new TaskModel('test item22'));
    childList[2].children.toList()[0].addChild(i);

    final interval = rootItem.renderInterval;
    rootItem = new SublistItem(root, interval);
  }

  @override
  void ngOnInit() {
    final childList = root.children.toList();
    final start = [root, childList[1]];
    final end = [root, childList[7], childList[7].children.toList()[1]];
    final interval = new RenderInterval(start, end);
    rootItem = new SublistItem(root, interval);
  }
}



class TreeViewStub implements TreeView {
  LinkedTree<TaskListModel> _tree;


  TreeViewStub() {
    print('new tree instance');

    _tree = new LinkedTree<TaskListModel>(new RootModel());
    for(int i = 0; i < 50; ++i) {
      final ni = new TaskModel('n ${i}');
      _tree.add(ni);

      for(int j = 0; j < 3; ++j) {
        final nj = new TaskModel('n ${i}:${j}');
        ni.addChild(nj);
      }
    }
  }

  @override
  LinkedTree<TaskListModel> get tree => _tree;

  @override
  Stream<Null> get onUpdate {
    return null;
  }
}