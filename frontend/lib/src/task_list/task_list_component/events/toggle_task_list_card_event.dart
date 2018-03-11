import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/task_list_component/events/task_list_card_event.dart';

class ToggleTaskListCardEvent extends TaskListCardEvent {
  final bool isExpanded;

  ToggleTaskListCardEvent(TaskListModel model, this.isExpanded): super(model);
}