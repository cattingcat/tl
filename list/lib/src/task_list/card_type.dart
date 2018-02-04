
/// Describes size map for cards
class CardType {
  /// Default task card preset
  static const CardType Default = const CardType._(40);
  /// Task card with minimal height
  static const CardType Narrow = const CardType._(20);


  final int taskCardHeight;
  final int folderCardHeight = 0;
  final int groupCardHeight = 0;

  const CardType._(this.taskCardHeight);
}