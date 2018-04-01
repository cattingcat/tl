import 'dart:async';

import 'package:frontend/src/task_list/models/task_list_model.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:w4p_core/collections.dart';

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