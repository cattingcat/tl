import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

/// Base class for card events in task-list
class TaskListCardEvent extends TaskCardEvent {
  TaskListCardEvent(TaskListModel model): super(model);
}