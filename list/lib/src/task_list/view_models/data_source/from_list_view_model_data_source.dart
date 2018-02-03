import 'package:list/src/task_list/view_models/task_list_view_model.dart';

class InMemoryViewModelDataSource {
  final List<TaskListViewModel> _data;

  InMemoryViewModelDataSource(this._data);

  int get length => _data.length;

  Iterable<TaskListViewModel> getInterval(int index, int count) {
    final end = index + count;
    return _data.sublist(index, end > _data.length - 1 ? _data.length - 1 : end);
  }
}