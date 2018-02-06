import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Flat representation of Model-tree
abstract class ListView {

  // TODO: Streams about changes


  /// Count of all models
  int get length;

  /// Current models
  Iterable<TaskListModelBase> get models;

  /// Get iterable regions of whole models list
  Iterable<TaskListModelBase> getRange(int start, int end);

  /// Returns index of model
  int indexOf(TaskListModelBase model);
}