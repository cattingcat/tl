import 'dart:html' as html;

import 'package:list/src/task_list/card_components/task_list_card_event.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';


class ClickCardEvent extends TaskCardEvent {
  final html.MouseEvent nativeEvent;

  ClickCardEvent(TaskListModelBase model, this.nativeEvent): super(model);
}