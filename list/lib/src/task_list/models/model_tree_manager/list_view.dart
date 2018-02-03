import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Flat representation of Model-tree
abstract class ListView {

  // TODO: Streams about changes

  /// Current models
  Iterable<TaskListModelBase> get models;
}