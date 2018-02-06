import 'package:list/src/task_list/models/model_tree_manager/sublist_stats.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

class ListViewEvent {
  final int index;
  final TaskListModelBase model;

  ListViewEvent(this.index, this.model);


  @override String toString() => 'Upd: $model at index $index';
}

class ListViewAddRemoveEvent extends ListViewEvent {
  final SublistStats stats;
  final bool updateAnchor;

  ListViewAddRemoveEvent(int index, TaskListModelBase model, this.stats, {this.updateAnchor = true}): super(index, model);


  @override String toString() => 'Add/Rm: anchor $model at index $index; stats: $stats; updAnch $updateAnchor';
}