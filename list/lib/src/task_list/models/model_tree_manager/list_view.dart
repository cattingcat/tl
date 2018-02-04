import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Flat representation of Model-tree
abstract class ListView {

  // TODO: Streams about changes


  /// Count of all models
  int get length;

  /// Current models
  Iterable<TaskListModelBase> get models;

  /// Get sublist of models
  Iterable<TaskListModelBase> sublist(int start, int end);
}