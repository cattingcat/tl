import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:w4p_core/collections.dart';

abstract class TaskListModel extends LinkedTreeEntry<TaskListModel> {
  final ModelType type;
  bool isExpanded = false;

  TaskListModel(this.type);


  @override
  String toString() => '${isExpanded ? '-' : '+'} $type';
}