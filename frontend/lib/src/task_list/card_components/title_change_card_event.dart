import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';

class TitleChangeCardEvent extends TaskCardEvent {
  final String title;

  TitleChangeCardEvent(TaskListModelBase model, this.title): super(model);
}