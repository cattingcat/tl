import 'package:angular/angular.dart';
import 'package:untitled1/src/task_list/core/task_list_model.dart';

@Component(
  selector: 'task-card',
  styleUrls: const ['task_card_component.scss.css'],
  templateUrl: 'task_card_component.html',
  directives: const [
    CORE_DIRECTIVES
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskCardComponent {
  @Input() TaskListModel model;
}