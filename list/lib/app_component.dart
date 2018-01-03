import 'package:angular/angular.dart';

import 'package:list/src/task_list_demo/task_list_demo.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: const <String>['app_component.scss.css'],
  templateUrl: 'app_component.html',
  directives: const <Object>[
    TaskListDemo
  ],
  //providers: const <Object>[materialProviders],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}
