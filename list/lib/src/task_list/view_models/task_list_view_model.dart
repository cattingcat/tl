import 'package:list/src/task_list/models/task_list_model_base.dart';

class TaskListViewModel {
  final TaskListModelBase model;
  final String text;

  TaskListViewModel(this.model, this.text);
}