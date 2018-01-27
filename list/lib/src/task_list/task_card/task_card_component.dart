import 'package:angular/angular.dart';
import 'package:list/src/core_components/directives/micro_interaction_hooks.dart';
import 'package:list/src/task_list/core/task_list_model.dart';

@Component(
  selector: 'task-card',
  styleUrls: const <String>['task_card_component.scss.css'],
  templateUrl: 'task_card_component.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    MicroInteractionHooks
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskCardComponent {
  @Input() TaskListModel model;
}