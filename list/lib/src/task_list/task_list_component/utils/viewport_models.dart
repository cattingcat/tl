import 'package:list/src/task_list/models/list_view/list_view.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class ViewportModels {
  final ListView _listView;
  List<TaskListModelBase> _models = new List<TaskListModelBase>();
  int _start = 0;
  int _end = 0;

  ViewportModels(this._listView);


  Iterable<TaskListModelBase> get models => _models;

  void setViewport(int start, int end) {
    _start = start;
    _end = end;
    _models = _listView.getRange(start, end).toList();
  }

  void takeFrontWhile(bool test(TaskListModelBase model)) {
    final range = _listView.takeWhileFrom(_end, Direction.Forward, test);
    final oldLen = _models.length;
    _models.addAll(range);
    _end += (_models.length - oldLen);
  }

  void takeBackWhile(bool test(TaskListModelBase model)) {
    final range = _listView.takeWhileFrom(_start - 1, Direction.Backward, test).toList();
    _models.insertAll(0, range.reversed);
    _start -= range.length;
  }

  void removeFrontWhile(bool test(TaskListModelBase model)) {
    for(int i = _models.length - 1; i > 0; --i) {
      final model = _models[i];
      if(test(model)) {
        _models.removeLast();
        --_end;
      } else {
        break;
      }
    }
  }

  void removeBackWhile(bool test(TaskListModelBase model)) {
    int removeCount = 0;
    for(int i = 0; i < _models.length; ++i) {
      final model = _models[i];
      if(test(model)) {
        ++_start;
        ++removeCount;
      } else {
        break;
      }
    }

    _models.removeRange(0, removeCount);

  }

  int getIndexOfModel(TaskListModelBase model) {
    return _models.indexOf(model) + _start;
  }
}