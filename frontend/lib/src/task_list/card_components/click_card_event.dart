import 'dart:html' as html;

import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';


class ClickCardEvent extends TaskCardEvent {
  final html.MouseEvent nativeEvent;

  ClickCardEvent(TaskListModel model, this.nativeEvent): super(model);
}