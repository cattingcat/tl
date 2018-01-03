import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:untitled1/src/task_list_demo/task_list_demo.dart';
import 'src/todo_list/todo_list_component.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.scss.css'],
  templateUrl: 'app_component.html',
  directives: const [
    materialDirectives,
    TodoListComponent,
    TaskListDemo
  ],
  providers: const <Object>[materialProviders],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}
