import 'package:list/src/task_list/models/group_model.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

class GroupCardModel extends TaskListViewModel {
  final GroupModel _model;

  GroupCardModel(this._model);


  @override
  TaskListModelBase get model => _model;

  @override
  String toString() => 'GroupCardModel $_model';
}