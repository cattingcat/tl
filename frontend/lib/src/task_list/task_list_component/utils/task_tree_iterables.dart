import 'package:frontend/src/task_list/models/task_list_model.dart';
import 'package:w4p_core/collections.dart';
import 'package:w4p_core/tree_iterables.dart';

class TaskTreeIterables {
  static Iterable<TaskListModel> forward(LinkedTree<TaskListModel> tree, [TaskListModel from]) {
    return new ForwardTreeIterable<TaskListModel>(tree, _visitChildren, from);
  }

  static Iterable<TaskListModel> backward(LinkedTree<TaskListModel> tree, [TaskListModel from]) {
    return new BackwardTreeIterable<TaskListModel>(tree, _visitChildren, from);
  }

  static Iterable<TaskListModel> subTree(TaskListModel node) {
    return new SubTreeIterable<TaskListModel>(node, _visitChildren);
  }


  static bool _visitChildren(TaskListModel model) => model.isExpanded;
}