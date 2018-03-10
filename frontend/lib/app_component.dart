import 'package:angular/angular.dart';
import 'package:frontend/src/app_header/app_header.dart';
import 'package:frontend/src/app_header/profile_model.dart';
import 'package:frontend/src/aside_menu/aside_menu.dart';
import 'package:frontend/src/dal/session.dart';
import 'package:frontend/src/task_list_demo/task_list_demo.dart';
import 'package:frontend/src/vsplit_container/vsplit_container.dart';

@Component(
  selector: 'my-app',
  styleUrls: const <String>['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const <Object>[
    NgIf,

    TaskListDemo,
    AppHeaderComponent,
    VsplitContainer,
    AsideMenuComponent
  ]
)
class AppComponent {
  bool menuHidden = true;
  bool menuPin = false;

  ProfileModel profile;

  AppComponent() {
    final session = Session.instance;

    if(session.hasToken()) {
      final userInfoMap = session.getUserInfo();
      final name = userInfoMap['login'];
      final ava = userInfoMap['avatar_url'];
      profile = new ProfileModel(name, ava);
    } else {
      profile = new ProfileModel('Peka Yobavich', 'https://2ch.hk/s/src/2256158/15191668427640.jpg');
    }
  }


  void onMenuToggle() {
    menuHidden = !menuHidden;
  }

  void onMenuPin() {
    menuPin = !menuPin;
  }
}
