import 'dart:html' as html;

import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';


class DndEvent extends TaskCardEvent {
  final html.MouseEvent nativeEvent;

  DndEvent(TaskListModel model, this.nativeEvent): super(model);
}
