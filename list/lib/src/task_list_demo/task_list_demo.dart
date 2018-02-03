import 'package:angular/angular.dart';
import 'package:list/src/task_list/task_card/task_card_component.dart';
import 'package:list/src/task_list/task_list_component.dart';
import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/view_models/data_source/from_list_view_model_data_source.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

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
  InMemoryViewModelDataSource dataSource;
  CardType cardType;

  TaskListDemo() {
    final list = new List<TaskListViewModel>();
    for(var i = 0; i < 10000; ++i) {
      list.add(new TaskListViewModel('iten no: $i'));
    }

    dataSource = new InMemoryViewModelDataSource(list);
    cardType = CardType.Default;
  }

  void changeDataSource() {
    final list = new List<TaskListViewModel>();
    for(var i = 0; i < 100; ++i) {
      list.add(new TaskListViewModel('!!!: $i'));
    }

    dataSource = new InMemoryViewModelDataSource(list);
  }

  void changeCardType() {
    if(cardType == CardType.Default) {
      cardType = CardType.Narrow;
    } else {
      cardType = CardType.Default;
    }
  }
}