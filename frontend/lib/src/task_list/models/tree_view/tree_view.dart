import 'dart:async';

import 'package:frontend/src/task_list/models/task_list_model.dart';
import 'package:w4p_core/collections.dart';

abstract class TreeView {
  LinkedTree<TaskListModel> get tree;

  Stream<Null> get onUpdate;
}