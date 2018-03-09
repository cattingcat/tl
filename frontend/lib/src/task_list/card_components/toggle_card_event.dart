import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';

class ToggleCardEvent extends TaskCardEvent {
  final bool isExpanded;

  ToggleCardEvent(TaskListModelBase model, this.isExpanded): super(model);
}