import 'package:angular/angular.dart';
import 'package:frontend/src/folder_task_list/task_list_demo.dart';
import 'package:frontend/src/task_view/task_view.dart';
import 'package:w4p_components/vsplit.dart';

@Component(
  selector: 'mvp-list',
  styleUrls: const <String>['mvp_list.css'],
  templateUrl: 'mvp_list.html',
  directives: const <Object>[
    TaskListDemo,
    VsplitContainer,
    TaskViewComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class MvpListComponent { }
