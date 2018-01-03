class CardType {
  static const Default = const CardType._(35);
  static const Narrow = const CardType._(20);

  final int height;

  const CardType._(this.height);
}