import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class ModelTreeManager {
  final LinkedTree<TaskListModelBase> _tree;

  ModelTreeManager(this._tree);


  LinkedTree<TaskListModelBase> get tree => _tree;

  ListView getListView() {
    final listView = new List<TaskListModelBase>();

    final stack = new List<Iterator<TaskListModelBase>>();
    var iterator = _tree.children.iterator;
    stack.add(iterator);

    while(stack.isNotEmpty) {
      while(iterator.moveNext()) {
        final model = iterator.current;
        listView.add(model);

        if(model.isExpanded) {
          iterator = model.children.iterator;

          stack.add(iterator);
        }
      }

      stack.removeLast();
      if(stack.isNotEmpty) {
        iterator = stack.last;
      }
    }

    return new ListView(listView);
  }
}