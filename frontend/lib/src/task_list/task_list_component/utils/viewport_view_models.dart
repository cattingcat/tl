import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';

/// Provides methods to work with [ViewModelDataSource]
///  optimal
class ViewportViewModels {
  final ViewModelDataSource _dataSource;
  final int _size;
  List<TaskListViewModel> _models;
  int _start = 0;

  ViewportViewModels(this._size, this._dataSource);


  int get start => _start;

  Iterable<TaskListViewModel> get viewModels => _models;

  Iterable<TaskListViewModel> setViewportStart(int startIndex) {
    final end = startIndex + _size;
    final len = _dataSource.length;
    final endIndex = end > len ? len : end;

    final oldStartIndex = _start;

    _start = startIndex;

    if(_models == null) {
      return _models = _dataSource.getRange(startIndex, endIndex).toList();
    }

    final oldEndIndex = oldStartIndex + _models.length;

    if(startIndex > oldEndIndex || endIndex < oldStartIndex || _models.length < _size) {
      return _models = _dataSource.getRange(startIndex, endIndex).toList();
    }

    if(startIndex > oldStartIndex) {
      final diff = startIndex - oldStartIndex;
      _models.removeRange(0, diff);
      final models = _dataSource.getRange(oldEndIndex, endIndex);
      _models.addAll(models);
      return _models;
    }

    if(startIndex < oldStartIndex) {
      final diff = oldStartIndex - startIndex;
      _models.removeRange(_models.length - diff, _models.length);
      final models = _dataSource.getRange(startIndex, oldStartIndex);
      _models.insertAll(0, models);
      return _models;
    }

    return _models = _dataSource.getRange(startIndex, endIndex).toList();
  }

  Iterable<TaskListViewModel> refresh() {
    final end = _start + _size;
    final len = _dataSource.length;
    final endIndex = end > len ? len : end;

    return _models = _dataSource.getRange(_start, endIndex).toList();
  }

  int getIndexOfModel(TaskListModel model) {
    final viewportIndex = _models.takeWhile((vm) => vm.model != model).length;

    return _start + viewportIndex;
  }
}