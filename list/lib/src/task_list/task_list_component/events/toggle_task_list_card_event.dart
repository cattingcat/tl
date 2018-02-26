import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/task_list_component/events/task_list_card_event.dart';

class ToggleTaskListCardEvent extends TaskListCardEvent {
  final bool isExpanded;

  ToggleTaskListCardEvent(TaskListModelBase model, this.isExpanded): super(model);
}