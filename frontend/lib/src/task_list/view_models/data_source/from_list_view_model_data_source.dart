import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';

class FromListViewModelDataSource implements ViewModelDataSource {
  final List<TaskListViewModel> _data;

  FromListViewModelDataSource(this._data);


  @override
  int get length => _data.length;

  @override
  Iterable<TaskListViewModel> getRange(int start, int end) {
    return _data.getRange(start, end);
  }

  @override
  Iterable<TaskListViewModel> map(Iterable<TaskListModelBase> models) {
    return null;
  }
}