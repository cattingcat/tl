import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/view_models/folder_card_model.dart';
import 'package:frontend/src/task_list/view_models/group_card_model.dart';
import 'package:frontend/src/task_list/view_models/sublist_view_model.dart';
import 'package:frontend/src/task_list/view_models/task_card_model.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';

/// Maps model collection to ViewModel collection
class ViewModelMapper  {
  TaskListViewModel mapModel(TaskListModel model) {
    switch(model.type) {
      case ModelType.Task:
        return new TaskCardModel(model);

      case ModelType.Folder:
        return new FolderCardModel(model);

      case ModelType.Group:
        return new GroupCardModel(model);

      default:
        assert(false, 'Unknown model type');
        return null;
    }
  }
}