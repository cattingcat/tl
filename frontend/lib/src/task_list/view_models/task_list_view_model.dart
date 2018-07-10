import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

abstract class TaskListViewModel {
  TaskListModel get model;


  bool get isTask => model.type == ModelType.task;

  bool get isGroup => model.type == ModelType.group;

  bool get isFolder => model.type == ModelType.folder;
}