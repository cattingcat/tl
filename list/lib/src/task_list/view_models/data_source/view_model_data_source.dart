import 'package:list/src/task_list/view_models/task_list_view_model.dart';

abstract class ViewModelDataSource {
  Iterable<TaskListViewModel> getInterval(int index, int count);
  int get length;
}