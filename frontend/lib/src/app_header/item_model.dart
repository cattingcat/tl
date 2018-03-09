class ItemModel {
  final String title;
  final String counter;
  final CounterLevel level;

  ItemModel(this.title, this.counter, this.level);


  bool get showIndicator =>
      level != CounterLevel.None && counter != null && counter.isNotEmpty;

  bool get isRed => showIndicator && level == CounterLevel.Red;

  bool get isYellow => showIndicator && level == CounterLevel.Yellow;
}

enum CounterLevel {
  None, Yellow, Red
}