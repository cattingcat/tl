import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

class FolderModel extends TaskListModel {
  FolderModel(): super(ModelType.folder);


  @override
  String toString() => '${super.toString()} ';
}