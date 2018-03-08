import 'package:list/src/task_list/card_components/click_card_event.dart';
import 'package:list/src/task_list/card_components/dnd_events.dart';
import 'package:list/src/task_list/card_components/title_change_card_event.dart';
import 'package:list/src/task_list/card_components/toggle_card_event.dart';

abstract class TaskCardObserver {
  void toggle(ToggleCardEvent event);

  void titleChange(TitleChangeCardEvent event);

  void click(ClickCardEvent event);


  void onDragOver(DndEvent event);

  void onDragLeave(DndEvent event);

  void onDragEnter(DndEvent event);

  void onDrop(DndEvent event);
}