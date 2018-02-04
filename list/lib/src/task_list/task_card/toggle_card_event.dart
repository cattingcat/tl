import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/task_card/task_list_card_event.dart';

class ToggleCardEvent extends TaskCardEvent {
  final bool isExpanded;

  ToggleCardEvent(TaskListModelBase model, this.isExpanded): super(model);
}