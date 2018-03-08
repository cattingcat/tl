import 'dart:async';

import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/tree_view/events.dart';
import 'package:list/src/task_list/models/tree_view/tree_view.dart';

class TreeViewImpl implements TreeView {
  TreeViewImpl(this.tree);


  @override
  final LinkedTree<TaskListModelBase> tree;


  @override
  Stream<AddTreeEvent> get onAdd => const Stream<AddTreeEvent>.empty();

  @override
  Stream<RemoveTreeEvent> get onRemove => const Stream<RemoveTreeEvent>.empty();

  @override
  Stream<UpdateTreeEvent> get onUpdate => const Stream<UpdateTreeEvent>.empty();
}