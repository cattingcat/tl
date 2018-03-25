import 'package:angular/angular.dart';
import 'package:frontend/src/task_list2/task_list.dart';

@Component(
  selector: 'mvp-dashboard',
  styleUrls: const <String>['mvp_dashboard.css'],
  templateUrl: 'mvp_dashboard.html',
  directives: const <Object>[
    TaskListComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class MvpDashboardComponent { }
