import 'package:list/src/task_list/core/task_list_model.dart';

class ModelDataSource {
  final List<TaskListModel> _data;

  ModelDataSource(this._data);

  int get length => _data.length;

  Iterable<TaskListModel> getInterval(int index, int count) {
    final end = index + count;
    return _data.sublist(index, end > _data.length - 1 ? _data.length - 1 : end);
  }
}