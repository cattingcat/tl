import 'package:frontend/src/task_list/models/task_list_model_base.dart';

/// Base class for all task card events
class TaskCardEvent {
  final TaskListModelBase model;

  TaskCardEvent(this.model);
}