import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/models/model_tree_manager/sublist_stats.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Flat representation of Model-tree
class ListViewImpl implements ListView {
  final List<TaskListModelBase> _models;

  ListViewImpl(this._models);


  void addModelsAfter(int index, SublistStats subListInfo) {
    _models.insertAll(index + 1, subListInfo.list);
  }

  void removeModelsAfter(int index, SublistStats subListInfo) {
    final count = subListInfo.list.length;
    _models.removeRange(index + 1, index + count + 1);
  }


  @override
  int get length => _models.length;

  @override
  Iterable<TaskListModelBase> get models => _models;

  @override
  Iterable<TaskListModelBase> getRange(int start, int end) {
    return _models.getRange(start, end);
  }

  @override
  int indexOf(TaskListModelBase model) {
    return _models.indexOf(model);
  }
}