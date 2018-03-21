import 'package:frontend/src/task_list/core/card_size_mapper.dart';
import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';


/// Describes size map for cards
class CardType implements CardSizeMapper<TaskListModel> {
  /// Default task card preset
  static const CardType Default = const CardType._(40);
  /// Task card with minimal height
  static const CardType Narrow = const CardType._(20);


  final int taskCardHeight;
  final int folderCardHeight = 20;
  final int groupCardHeight = 20;

  const CardType._(this.taskCardHeight);


  @override
  int getHeight(TaskListModel model) {
    switch(model.type) {
      case ModelType.Task: return taskCardHeight;
      case ModelType.Folder: return folderCardHeight;
      case ModelType.Group: return groupCardHeight;
      default: return null;
    }
  }
}