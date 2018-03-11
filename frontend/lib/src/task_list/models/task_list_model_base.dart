import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/model_type.dart';

abstract class TaskListModel extends LinkedTreeEntry<TaskListModel> {
  final ModelType type;
  bool isExpanded = false;

  TaskListModel(this.type);


  @override
  String toString() => '${isExpanded ? '-' : '+'} $type';
}