import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:frontend/src/app_header/app_header.dart';
import 'package:frontend/src/app_menus/app_menus.dart';
import 'package:frontend/src/dal/session.dart';
import 'package:frontend/src/routes/routes.dart';

@Component(
  selector: 'my-app',
  styleUrls: const <String>['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const <Object>[
    routerDirectives,

    NgIf,

    AppMenusComponent
  ],
  providers: const <Object>[
    const ClassProvider<Routes>(Routes)
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class AppComponent {
  final _listItem = new ItemModel('List', '', CounterLevel.None);
  final _dashboardItem = new ItemModel('Dashboard', '2', CounterLevel.None);
  final _notesItem = new ItemModel('Notes', '3', CounterLevel.Yellow);

  final Router _router;
  final Routes routes;

  ProfileModel profile;
  Iterable<ItemModel> headerItems;
  ItemModel activeItem;


  AppComponent(this._router, this.routes) {
    final session = Session.instance;

    final userInfoMap = session.getUserInfo();
    final name = userInfoMap['login'];
    final ava = userInfoMap['avatar_url'];
    profile = new ProfileModel(name, ava);

    headerItems = [
      _listItem,
      _dashboardItem,
      _notesItem,
      new ItemModel('...', '4', CounterLevel.Red)
    ];
  }

  void onChooseMvp(ItemModel headerItem) {
    String uri = '';
    if(headerItem == _listItem) {
      uri = Routes.listPath.toUrl();
    }else if(headerItem == _dashboardItem) {
      uri = Routes.dashboardPath.toUrl();
    } else if(headerItem == _notesItem) {
      uri = Routes.notesPath.toUrl();
    }

    _router.navigate(uri);
    activeItem = headerItem;
  }
}
