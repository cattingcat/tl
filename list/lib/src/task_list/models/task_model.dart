import 'package:list/src/task_list/models/model_type.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class TaskModel extends TaskListModelBase {
  Object task;

  TaskModel(): super(ModelType.Task);
}