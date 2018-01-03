import 'package:angular/angular.dart';
import 'package:untitled1/src/task_list/core/model_data_source.dart';
import 'package:untitled1/src/task_list/core/task_list_model.dart';
import 'package:untitled1/src/task_list/task_card/task_card_component.dart';
import 'package:untitled1/src/task_list/task_list_component.dart';

@Component(
    selector: 'task-list-demo',
    templateUrl: 'task_list_demo.html',
    directives: const [
      CORE_DIRECTIVES,
      TaskCardComponent,
      TaskListComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListDemo {
  ModelDataSource dataSource;

  TaskListDemo() {
    final list = new List<TaskListModel>();
    for(var i = 0; i < 10000; ++i) {
      list.add(new TaskListModel('iten no: $i'));
    }

    dataSource = new ModelDataSource(list);
  }

  void onClick() {
    final list = new List<TaskListModel>();
    for(var i = 0; i < 100; ++i) {
      list.add(new TaskListModel('!!!: $i'));
    }

    dataSource = new ModelDataSource(list);
  }
}