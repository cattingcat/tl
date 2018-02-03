
/// Describes type of task-card
class CardType {
  /// Default task card preset
  static const CardType Default = const CardType._(35);
  /// Task card with minimal height
  static const CardType Narrow = const CardType._(20);

  final int height;

  const CardType._(this.height);
}