import 'dart:async';

import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/tree_view/events.dart';

abstract class TreeView {
  LinkedTree<TaskListModel> get tree;

  Stream<Null> get onUpdate;
}