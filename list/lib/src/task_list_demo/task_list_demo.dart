import 'package:angular/angular.dart';
import 'package:list/src/task_list/core/card_type.dart';
import 'package:list/src/task_list/core/model_data_source.dart';
import 'package:list/src/task_list/core/task_list_model.dart';
import 'package:list/src/task_list/task_card/task_card_component.dart';
import 'package:list/src/task_list/task_list_component.dart';

@Component(
    selector: 'task-list-demo',
    templateUrl: 'task_list_demo.html',
    directives: const <Object>[
      CORE_DIRECTIVES,
      TaskCardComponent,
      TaskListComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListDemo {
  ModelDataSource dataSource;
  CardType cardType;

  TaskListDemo() {
    final list = new List<TaskListModel>();
    for(var i = 0; i < 10000; ++i) {
      list.add(new TaskListModel('iten no: $i'));
    }

    dataSource = new ModelDataSource(list);
    cardType = CardType.Default;
  }

  void changeDataSource() {
    final list = new List<TaskListModel>();
    for(var i = 0; i < 100; ++i) {
      list.add(new TaskListModel('!!!: $i'));
    }

    dataSource = new ModelDataSource(list);
  }

  void changeCardType() {
    if(cardType == CardType.Default) {
      cardType = CardType.Narrow;
    } else {
      cardType = CardType.Default;
    }
  }
}