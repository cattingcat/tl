import 'package:list/src/task_list/models/folder_model.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

class FolderCardModel extends TaskListViewModel {
  final FolderModel _model;

  FolderCardModel(this._model);


  @override
  TaskListModelBase get model => _model;

  @override
  String toString() => 'FolderCardModel $_model';
}