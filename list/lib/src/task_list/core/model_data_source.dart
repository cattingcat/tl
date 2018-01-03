import 'package:untitled1/src/task_list/core/task_list_model.dart';

class ModelDataSource {
  final List<TaskListModel> _data;

  ModelDataSource(this._data);

  int get length => _data.length;

  Iterable<TaskListModel> getInterval(int index, int count) {
    return _data.sublist(index, index + count);
  }
}