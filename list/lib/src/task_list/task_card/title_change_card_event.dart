import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/task_card/task_list_card_event.dart';

class TitleChangeCardEvent extends TaskCardEvent {
  final String title;

  TitleChangeCardEvent(TaskListModelBase model, this.title): super(model);
}