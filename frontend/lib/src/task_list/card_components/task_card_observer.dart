import 'dart:html' as html;

import 'package:frontend/src/task_list/card_components/mouse_card_event.dart';
import 'package:frontend/src/task_list/card_components/dnd_events.dart';
import 'package:frontend/src/task_list/card_components/title_change_card_event.dart';
import 'package:frontend/src/task_list/card_components/toggle_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';

abstract class TaskCardObserver {
  const factory TaskCardObserver.stub() = _TaskCardObserverStub;

  void toggle(ToggleCardEvent event);

  void titleChange(TitleChangeCardEvent event);

  void click(MouseCardEvent event);


  void onDragOver(TaskListModel model, html.MouseEvent event);

  void onDragLeave(TaskListModel model, html.MouseEvent event);

  void onDragEnter(TaskListModel model, html.MouseEvent event);

  void onDrop(TaskListModel model, html.MouseEvent event);


  void onMouseEnter(MouseCardEvent event);

  void onMouseLeave(MouseCardEvent event);

  void onMouseMove(MouseCardEvent event);
}


class _TaskCardObserverStub implements TaskCardObserver {
  const _TaskCardObserverStub();

  @override
  dynamic noSuchMethod(Invocation invocation) {
   return null;
  }
}