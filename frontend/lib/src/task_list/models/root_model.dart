import 'package:frontend/src/task_list/models/task_list_model_base.dart';

class RootModel extends TaskListModel {
  RootModel(): super(null);


  @override
  bool get isExpanded => true;

  @override
  String toString() => 'root';
}