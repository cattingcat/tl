import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

class GroupModel extends TaskListModel {
  GroupModel(): super(ModelType.Group);


  @override
  String toString() => '${super.toString()} ';
}