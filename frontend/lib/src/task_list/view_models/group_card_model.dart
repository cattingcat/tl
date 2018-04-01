import 'package:frontend/src/task_list/models/group_model.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';

class GroupCardModel extends TaskListViewModel {
  final GroupModel _model;

  GroupCardModel(this._model);


  @override
  TaskListModel get model => _model;

  @override
  String toString() => 'GroupCardModel $_model';
}