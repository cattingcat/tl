import 'package:list/src/task_list/models/model_type.dart';


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


  int getHeight(ModelType modelType) {
    switch(modelType) {
      case ModelType.Task: return taskCardHeight;
      case ModelType.Folder: return folderCardHeight;
      case ModelType.Group: return groupCardHeight;
      default: return null;
    }
  }
}