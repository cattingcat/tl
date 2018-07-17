import 'dart:async';

import 'package:angular/angular.dart';
// ignore: uri_has_not_been_generated
import 'package:frontend/src/mvp_task_view/task_view/task_view.template.dart'deferred as task_view;

@Component(
    selector: 'mvp-task-view-loader',
    styles: const <String>[':host {display: block; height: 100%;}'],
    templateUrl: 'task_view_loader.html',
    directives: const <Object>[],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskViewLoaderComponent implements OnInit {
  final ComponentLoader _loader;

  @ViewChild('container', read: ViewContainerRef)
  ViewContainerRef container;

  TaskViewLoaderComponent(this._loader);

  @override
  Future<void> ngOnInit() async {
    await task_view.loadLibrary();

    task_view.initReflector();

    final factory = task_view.TaskViewComponentNgFactory;
    final componentRef = _loader.loadNextToLocation(factory, container);
    //componentRef.instance.name = 'qwe';

    componentRef.changeDetectorRef
      ..markForCheck()
      ..detectChanges();
  }
}
