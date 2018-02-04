import 'package:angular/angular.dart';
import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/models/model_tree_manager/model_tree_manager.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/task_model.dart';
import 'package:list/src/task_list/task_card/default/task_card_component.dart';
import 'package:list/src/task_list/task_card/toggle_card_event.dart';
import 'package:list/src/task_list/task_list_component.dart';
import 'package:list/src/task_list/card_type.dart';

@Component(
    selector: 'task-list-demo',
    templateUrl: 'task_list_demo.html',
    styleUrls: const <String>['task_list_demo.scss.css'],
    directives: const <Object>[
      CORE_DIRECTIVES,
      TaskCardComponent,
      TaskListComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListDemo {
  ModelTreeManager _treeManager;

  ListView listView;
  CardType cardType;

  TaskListDemo() {
    final tree = new LinkedTree<TaskListModelBase>();
    for(int i = 0; i < 100; ++i) {
      final task = new TaskModel('$i');

      for(int j = 0; j < i; ++j) {
        final subTask = new TaskModel('$i ; $j');
        task.addChild(subTask);
      }

      tree.addFirst(task);
    }
    _treeManager = new ModelTreeManager(tree);

    listView = _treeManager.getListView();
    cardType = CardType.Default;
  }

  void onCardToggle(ToggleCardEvent event) {
    _treeManager.toggle(event.model);
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
}