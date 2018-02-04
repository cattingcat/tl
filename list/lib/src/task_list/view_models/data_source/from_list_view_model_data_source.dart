import 'package:list/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

class InMemoryViewModelDataSource implements ViewModelDataSource {
  final List<TaskListViewModel> _data;

  InMemoryViewModelDataSource(this._data);


  @override
  int get length => _data.length;

  @override
  Iterable<TaskListViewModel> getInterval(int index, int count) {
    final end = index + count;
    return _data.sublist(index, end > _data.length - 1 ? _data.length - 1 : end);
  }
}