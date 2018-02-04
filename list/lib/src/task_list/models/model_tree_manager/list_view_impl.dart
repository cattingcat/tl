import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Flat representation of Model-tree
class ListViewImpl implements ListView {
  final List<TaskListModelBase> _models;

  ListViewImpl(this._models);


  void addModelsAfter(TaskListModelBase anchor, List<TaskListModelBase> subList) {
    final index = _models.indexOf(anchor);
    assert(index != -1, 'Anchor should be in list');

    _models.insertAll(index + 1, subList);
  }

  void removeModelsAfter(TaskListModelBase anchor, int count) {
    final index = _models.indexOf(anchor);
    assert(index != -1, 'Anchor should be in list');

    _models.removeRange(index + 1, index + count + 1);
  }


  @override
  int get length => _models.length;

  @override
  Iterable<TaskListModelBase> get models => _models;

  @override
  Iterable<TaskListModelBase> sublist(int start, int end) {
    return _models.getRange(start, end);
  }
}