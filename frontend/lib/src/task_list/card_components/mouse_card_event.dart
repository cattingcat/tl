import 'dart:html' as html;

import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';


class MouseCardEvent extends TaskCardEvent {
  final html.MouseEvent nativeEvent;
  final html.Element nativeElement;

  MouseCardEvent(TaskListModel model, this.nativeEvent, this.nativeElement): super(model);
}

