import 'package:list/src/task_list/models/model_type.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class TaskModel extends TaskListModelBase {
  final Object task;

  TaskModel(this.task): super(ModelType.Task);


  @override
  String toString() => '$type: $task';
}