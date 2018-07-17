import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/overlay/overlay_component.dart';
import 'package:frontend/src/folder_task_list/task_list_demo.dart';
import 'package:frontend/src/mvp_task_view/task_view_loader_component.dart';
import 'package:w4p_components/vsplit.dart';

@Component(
  selector: 'mvp-list',
  styleUrls: const <String>['mvp_list.css'],
  templateUrl: 'mvp_list.html',
  directives: const <Object>[
    NgIf,

    TaskListDemo,
    VsplitContainer,
    TaskViewLoaderComponent,

    OverlayComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class MvpListComponent {
  bool showOverlay = false;

  void onOverlayClose() {
    showOverlay = false;
  }

  void onOverlayShow() {
    showOverlay = true;
  }
}
