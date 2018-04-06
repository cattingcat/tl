import 'package:angular/angular.dart';
import 'package:frontend/src/app_header/app_header.dart';
import 'package:frontend/src/app_menus/app_menus.dart';
import 'package:frontend/src/dal/session.dart';
import 'package:frontend/src/mvp_dashboard/mvp_dashboard.dart';
import 'package:frontend/src/mvp_list/mvp_list.dart';
import 'package:frontend/src/mvp_notes/notes_loader_component.dart';

@Component(
  selector: 'my-app',
  styleUrls: const <String>['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const <Object>[
    NgIf,

    AppMenusComponent,

    MvpListComponent,
    MvpDashboardComponent,
    NotesLoaderComponent
  ],
  exports: const <Type>[Mvps],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class AppComponent {
  final _listItem = new ItemModel('List', '', CounterLevel.None);
  final _dashboardItem = new ItemModel('Dashboard', '2', CounterLevel.None);
  final _notesItem = new ItemModel('Notes', '3', CounterLevel.Yellow);

  Mvps activeMvp = Mvps.List; // TODO: Normal routing

  ProfileModel profile;
  Iterable<ItemModel> headerItems;
  ItemModel activeItem;


  AppComponent() {
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
    if(headerItem == _listItem) activeMvp = Mvps.List;
    if(headerItem == _dashboardItem) activeMvp = Mvps.Dashboards;
    if(headerItem == _notesItem) activeMvp = Mvps.Notes;

    activeItem = headerItem;
  }
}

enum Mvps {
  List, Dashboards, Notes
}