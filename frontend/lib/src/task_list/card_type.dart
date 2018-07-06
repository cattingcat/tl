import 'package:frontend/src/task_list/core/card_size_mapper.dart';
import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';


/// Describes size map for cards
class CardType implements CardSizeMapper<TaskListModel> {
  /// Default task card preset
  static const CardType defaultCard = const CardType._(40);
  /// Task card with minimal height
  static const CardType narrowCard = const CardType._(20);


  final int taskCardHeight;
  final int folderCardHeight = 20;
  final int groupCardHeight = 20;

  const CardType._(this.taskCardHeight);


  @override
  int getHeight(TaskListModel model) {
    switch(model.type) {
      case ModelType.task: return taskCardHeight;
      case ModelType.folder: return folderCardHeight;
      case ModelType.group: return groupCardHeight;
      default: return null;
    }
  }
}