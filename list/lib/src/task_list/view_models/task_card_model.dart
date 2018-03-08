import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/task_model.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

class TaskCardModel extends TaskListViewModel {
  final TaskModel _model;

  TaskCardModel(this._model);


  @override
  TaskListModelBase get model => _model;

  @override
  String toString() => 'TaskCardModel $_model';
}