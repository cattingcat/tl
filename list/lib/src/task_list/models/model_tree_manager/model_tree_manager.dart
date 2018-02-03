import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class ModelTreeManager {
  final LinkedTree<TaskListModelBase> _tree;
  ListView _listView;

  ModelTreeManager(this._tree);


  LinkedTree<TaskListModelBase> get tree => _tree;

  ListView getListView() {
    final listView = _getListViewFor(_tree.children);

    return _listView = new ListView(listView);
  }


  void expand(TaskListModelBase model) {
    assert(model != null, 'Model shouldnt be null');
    if(model.isExpanded || _listView == null || model.children.isEmpty) return;

    model.isExpanded = true;
    final list = _getListViewFor(model.children);

    // TODO: update event on expanded task

    _listView.addModelsAfter(model, list);
  }

  void collapse(TaskListModelBase model) {
    assert(model != null, 'Model shouldnt be null');
    if(!model.isExpanded || _listView == null || model.children.isEmpty) return;

    model.isExpanded = false;
    final list = _getListViewFor(model.children);

    _listView.removeModelsAfter(model, list.length);
  }

  void toggle(TaskListModelBase model) {
    assert(model != null, 'Model shouldnt be null');

    if(model.isExpanded) {
      collapse(model);
    } else {
      expand(model);
    }
  }


  List<TaskListModelBase> _getListViewFor(Iterable<TaskListModelBase> children) {
    final listView = new List<TaskListModelBase>();

    final stack = new List<Iterator<TaskListModelBase>>();
    var iterator = children.iterator;
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

    return listView;
  }
}