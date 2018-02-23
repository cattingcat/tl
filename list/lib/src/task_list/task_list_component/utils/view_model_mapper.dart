import 'package:list/src/task_list/models/model_type.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/view_models/folder_card_model.dart';
import 'package:list/src/task_list/view_models/group_card_model.dart';
import 'package:list/src/task_list/view_models/sublist_view_model.dart';
import 'package:list/src/task_list/view_models/task_card_model.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

/// Maps model collection to ViewModel collection
class ViewModelMapper  {
  SublistViewModel map2(Iterable<TaskListModelBase> models) {
    assert(models != null && models.isNotEmpty, 'Models required');

    final skeleton = buildSkeleton(models.first.parent);

    final modelsMap = skeleton.modelsMap;

    for(var model in models) {
      final parentVm = modelsMap[model.parent];

      final viewModel = _mapModel(model);
      final sublistVm = new MutableSublistViewModel(viewModel, true);

      modelsMap[model] = sublistVm;

      parentVm.sublist.add(sublistVm);
    }

    return skeleton.viewModel;
  }

  Iterable<TaskListViewModel> map(Iterable<TaskListModelBase> models) {
    return models.map(_mapModel);
  }

  TaskListViewModel _mapModel(TaskListModelBase model) {
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

  /// Returns sublist view-models for [model]
  /// Don't use outside
  BuildResult buildSkeleton(TaskListModelBase model) {
    if(model == null) {
      final modelsMap = new Map<TaskListModelBase, MutableSublistViewModel>();
      final rootVm = new MutableSublistViewModel(null, false);

      modelsMap[null] = rootVm;

      return new BuildResult(rootVm, modelsMap);
    }


    TaskListModelBase root = model;
    TaskListViewModel rootViewModel = _mapModel(model);
    MutableSublistViewModel rootSublist = new MutableSublistViewModel(rootViewModel, false);

    final modelsMap = new Map<TaskListModelBase, MutableSublistViewModel>();
    modelsMap[root] = rootSublist;

    root = root.parent;
    while(root != null) {
      rootViewModel = _mapModel(root);
      final svm = new MutableSublistViewModel(rootViewModel, false);
      svm.sublist.add(rootSublist);

      modelsMap[root] = svm;

      rootSublist = svm;
      root = root.parent;
    }

    final rootSvm = new MutableSublistViewModel(null, false)
      ..sublist.add(rootSublist);

    return new BuildResult(rootSvm, modelsMap);
  }
}

class MutableSublistViewModel implements SublistViewModel{
  @override TaskListViewModel model;
  @override List<SublistViewModel> sublist = new List<SublistViewModel>();
  @override bool showHeader;
  @override bool get showSublist => sublist.isNotEmpty;

  MutableSublistViewModel(this.model, this.showHeader);
}

class BuildResult {
  final MutableSublistViewModel viewModel;
  final Map<TaskListModelBase, MutableSublistViewModel> modelsMap;

  BuildResult(this.viewModel, this.modelsMap);
}