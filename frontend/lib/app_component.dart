import 'package:angular/core.dart';
import 'package:list/src/app_header/app_header.dart';
import 'package:list/src/task_list_demo/task_list_demo.dart';

@Component(
  selector: 'my-app',
  styleUrls: const <String>['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const <Object>[
    TaskListDemo,
    AppHeaderComponent
  ]
)
class AppComponent { }
