import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';

/// Represents model-list statistics
class SublistStats {
  final Map<ModelType, int> _data;

  SublistStats(this.list, this._data);

  /// List of models
  final List<TaskListModel> list;

  /// Count on task-models in [list]
  int get taskCount => _data[ModelType.task];

  /// Count on group-models in [list]
  int get groupCount => _data[ModelType.group];

  /// Count on folder-models in [list]
  int get folderCount => _data[ModelType.folder];


  @override String toString() => 'T: $taskCount; G: $groupCount; F: $folderCount';
}