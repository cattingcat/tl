import 'dart:async';

import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/tree_view/events.dart';

abstract class TreeView {
  LinkedTree<TaskListModelBase> get tree;

  Stream<AddTreeEvent> get onAdd;

  Stream<RemoveTreeEvent> get onRemove;

  Stream<UpdateTreeEvent> get onUpdate;
}