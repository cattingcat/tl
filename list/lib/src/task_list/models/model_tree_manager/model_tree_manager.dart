import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/models/model_tree_manager/list_view_impl.dart';
import 'package:list/src/task_list/models/model_tree_manager/sublist_stats.dart';
import 'package:list/src/task_list/models/model_type.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class ModelTreeManager {
  final LinkedTree<TaskListModelBase> _tree;
  ListViewImpl _listView;

  ModelTreeManager(this._tree);


  LinkedTree<TaskListModelBase> get tree => _tree;

  ListView getListView() {
    if(_listView != null) return _listView;

    final stats = _getListViewFor(_tree.children);

    return _listView = new ListViewImpl(stats.list);
  }


  void expand(TaskListModelBase model, {int index = -1}) {
    assert(model != null, 'Model shouldnt be null');
    if(model.isExpanded || _listView == null || model.children.isEmpty) return;

    model.isExpanded = true;
    final stats = _getListViewFor(model.children);

    // TODO: update event on expanded task
    final i = index != -1 ? index : _listView.indexOf(model);
    _listView.addModelsAfter(i, stats);
  }

  void collapse(TaskListModelBase model, {int index = -1}) {
    assert(model != null, 'Model shouldnt be null');
    if(!model.isExpanded || _listView == null || model.children.isEmpty) return;

    model.isExpanded = false;
    final stats = _getListViewFor(model.children);

    final i = index != -1 ? index : _listView.indexOf(model);
    _listView.removeModelsAfter(i, stats);
  }

  void toggle(TaskListModelBase model, {int index = -1}) {
    assert(model != null, 'Model shouldnt be null');

    if(model.isExpanded) {
      collapse(model, index: index);
    } else {
      expand(model, index: index);
    }
  }


  SublistStats _getListViewFor(Iterable<TaskListModelBase> children) {
    final listView = new List<TaskListModelBase>();
    final Map<ModelType, int> stats = {
      ModelType.Task: 0,
      ModelType.Group: 0,
      ModelType.Folder: 0
    };

    final stack = new List<Iterator<TaskListModelBase>>();
    var iterator = children.iterator;
    stack.add(iterator);

    while(stack.isNotEmpty) {
      while(iterator.moveNext()) {
        final model = iterator.current;

        listView.add(model);
        ++stats[model.type];

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

    return new SublistStats(listView, stats);
  }
}
