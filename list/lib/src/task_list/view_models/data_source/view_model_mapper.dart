import 'package:list/src/task_list/models/list_view/list_view.dart';
import 'package:list/src/task_list/models/model_type.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:list/src/task_list/view_models/folder_card_model.dart';
import 'package:list/src/task_list/view_models/group_card_model.dart';
import 'package:list/src/task_list/view_models/task_card_model.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

/// Maps model collection to ViewModel collection
class ViewModelMapper  {
  Iterable<TaskListViewModel> map(Iterable<TaskListModelBase> models) {
    return models.map((i) {
      switch(i.type) {
        case ModelType.Task:
          return new TaskCardModel(i);

        case ModelType.Folder:
          return new FolderCardModel(i);

        case ModelType.Group:
          return new GroupCardModel(i);

        default:
          assert(false, 'Unknown model type');
      }
    });
  }
}