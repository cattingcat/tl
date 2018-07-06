import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

class TaskModel extends TaskListModel {
  final Object task;

  TaskModel(this.task): super(ModelType.task);


  @override
  String toString() => '${super.toString()}: $task';
}