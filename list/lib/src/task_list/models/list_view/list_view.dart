import 'dart:async';
import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/list_view/events.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Flat representation of Model-tree
/// TODO: TreeView
abstract class ListView {
  LinkedTree<TaskListModelBase> get tree;


  /// Triggered when models range was added into list
  Stream<ListViewAddRemoveEvent> get onAdd;

  /// Triggered when models range was removed
  Stream<ListViewAddRemoveEvent> get onRemove;

  /// Triggered when model updated
  Stream<ListViewEvent> get onUpdate;

  /// Count of all models
  int get length;

  /// Current models
  Iterable<TaskListModelBase> get models;

  /// Get iterable regions of whole models list
  Iterable<TaskListModelBase> getRange(int start, int end);

  /// Returns index of model
  int indexOf(TaskListModelBase model);

  /// Take list items from some [index] until [test] returns true
  Iterable<TaskListModelBase> takeWhileFrom(int index, Direction direction, bool test(TaskListModelBase model));
}

enum Direction {
  Forward, Backward
}