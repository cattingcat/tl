import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';

/// Base class for card events in task-list
class TaskListCardEvent extends TaskCardEvent {
  TaskListCardEvent(TaskListModelBase model): super(model);
}