import 'package:list/src/task_list/models/model_type.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class GroupModel extends TaskListModelBase {
  GroupModel(): super(ModelType.Group);


  @override
  String toString() => '${super.toString()} ';
}