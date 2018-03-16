import 'dart:html' as html;

import 'package:frontend/src/task_list/card_components/mouse_card_event.dart';


class ListMouseCardEvent extends MouseCardEvent {
  final html.Point<int> listOffset;

  ListMouseCardEvent.fromCardEvent(MouseCardEvent event, this.listOffset):
        super(event.model, event.nativeEvent, event.nativeElement);
}