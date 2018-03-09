import 'dart:html' as html;

import 'package:frontend/src/app_header/item_model.dart';


class HeaderItemClickEvent {
  final html.MouseEvent nativeEvent;

  HeaderItemClickEvent(this.nativeEvent);
}

class RadioItemClickEvent extends HeaderItemClickEvent {
  final ItemModel model;

  RadioItemClickEvent(html.MouseEvent nativeEvent, this.model): super(nativeEvent);
}