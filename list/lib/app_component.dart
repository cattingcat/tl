import 'package:angular/angular.dart';

import 'package:list/src/task_list_demo/task_list_demo.dart';

@Component(
  selector: 'my-app',
  styleUrls: const <String>['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const <Object>[
    TaskListDemo
  ]
)
class AppComponent { }
