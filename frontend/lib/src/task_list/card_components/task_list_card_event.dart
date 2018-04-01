import 'package:frontend/src/task_list/models/task_list_model.dart';

/// Base class for all task card events
class TaskCardEvent {
  final TaskListModel model;

  TaskCardEvent(this.model);
}