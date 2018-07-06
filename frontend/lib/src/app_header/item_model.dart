class ItemModel {
  final String title;
  final String counter;
  final CounterLevel level;

  ItemModel(this.title, this.counter, this.level);


  bool get showIndicator =>
      level != CounterLevel.none && counter != null && counter.isNotEmpty;

  bool get isRed => showIndicator && level == CounterLevel.red;

  bool get isYellow => showIndicator && level == CounterLevel.yellow;
}

enum CounterLevel {
  none, yellow, red
}