import 'package:list/src/task_list/card_components/title_change_card_event.dart';
import 'package:list/src/task_list/card_components/toggle_card_event.dart';

abstract class TaskCardObserver {
  void toggle(ToggleCardEvent event);

  void titleChange(TitleChangeCardEvent event);
}