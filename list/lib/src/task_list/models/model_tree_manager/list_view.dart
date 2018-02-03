import 'package:list/src/task_list/models/task_list_model_base.dart';

class ListView {
  final List<TaskListModelBase> _models;

  ListView(this._models);

  Iterable<TaskListModelBase> get models => _models;

  void addModelsAfter(TaskListModelBase anchor, List<TaskListModelBase> subList) {
    final index = _models.indexOf(anchor);
    assert(index != -1, 'Anchor should be in list');

    _models.insertAll(index + 1, subList);
  }

  void removeModelsAfter(TaskListModelBase anchor, int count) {
    final index = _models.indexOf(anchor);
    assert(index != -1, 'Anchor should be in list');

    _models.removeRange(index + 1, index + count + 1);
  }
}