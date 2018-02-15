import 'package:list/src/task_list/models/list_view/list_view.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class ViewportModels {
  final ListView _listView;
  List<TaskListModelBase> _models;
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

  }

  void removeBackWhile(bool test(TaskListModelBase model)) {

  }
}