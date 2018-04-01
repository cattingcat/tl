import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

abstract class TaskListViewModel {
  TaskListModel get model;


  bool get isTask => model.type == ModelType.Task;

  bool get isGroup => model.type == ModelType.Group;

  bool get isFolder => model.type == ModelType.Folder;
}