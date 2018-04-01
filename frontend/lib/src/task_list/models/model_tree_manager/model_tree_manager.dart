import 'package:frontend/src/task_list/models/task_list_model.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view_impl.dart';
import 'package:w4p_core/collections.dart';

class ModelTreeManager {
  final LinkedTree<TaskListModel> _tree;

  ModelTreeManager(this._tree);


  LinkedTree<TaskListModel> get tree => _tree;

  TreeView getTreeView() {
    return new TreeViewImpl(_tree);
  }
}
