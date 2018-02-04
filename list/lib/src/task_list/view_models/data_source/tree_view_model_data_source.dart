import 'package:list/src/task_list/models/model_tree_manager/list_view.dart';
import 'package:list/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

class TreeViewModelDataSource implements ViewModelDataSource {
  ListView _view;

  TreeViewModelDataSource(this._view);


  @override
  int get length => _view.length;

  @override
  Iterable<TaskListViewModel> getRange(int start, int end) {
    final models = _view.getRange(start, end);

    return models.map((i) => new TaskListViewModel(i, i.toString()));
  }
}