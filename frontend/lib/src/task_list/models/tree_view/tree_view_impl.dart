import 'dart:async';

import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/tree_view/events.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';

class TreeViewImpl implements TreeView {
   final _updateCtrl = new StreamController<Null>(sync: true);

  TreeViewImpl(this.tree);


  void update() {
    _updateCtrl.add(null);
  }


  @override
  final LinkedTree<TaskListModel> tree;

  @override
  Stream<Null> get onUpdate => _updateCtrl.stream;
}