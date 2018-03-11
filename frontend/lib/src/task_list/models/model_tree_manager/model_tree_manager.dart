import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view_impl.dart';

class ModelTreeManager {
  final LinkedTree<TaskListModel> _tree;

  ModelTreeManager(this._tree);


  LinkedTree<TaskListModel> get tree => _tree;

  TreeView getTreeView() {
    return new TreeViewImpl(_tree);
  }
}
