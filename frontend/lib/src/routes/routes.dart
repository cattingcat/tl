import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

// ignore: uri_has_not_been_generated
import 'package:frontend/src/mvp_dashboard/mvp_dashboard.template.dart' as dashboard_template;
// ignore: uri_has_not_been_generated
import 'package:frontend/src/mvp_list/mvp_list.template.dart' as list_template;
// ignore: uri_has_not_been_generated
import 'package:frontend/src/mvp_notes/notes_loader_component.template.dart' as notes_template;

const String noteIdParam = 'id';

@Injectable()
class Routes {
  static final RoutePath notesIdPath = new RoutePath(path: 'notes/:$noteIdParam');
  static final RoutePath notesPath = new RoutePath(path: 'notes');
  static final RoutePath listPath = new RoutePath(path: 'list');
  static final RoutePath dashboardPath = new RoutePath(path: 'dashboard');

  static final _notes = new RouteDefinition(
    routePath: notesPath,
    component: notes_template.NotesLoaderComponentNgFactory
  );

  static final _notesId = new RouteDefinition(
      routePath: notesIdPath,
      component: notes_template.NotesLoaderComponentNgFactory
  );

  static final _list = new RouteDefinition(
    routePath: listPath,
    component: list_template.MvpListComponentNgFactory
  );

  static final _dashboard = new RouteDefinition(
    routePath: dashboardPath,
    component: dashboard_template.MvpDashboardComponentNgFactory
  );


  RouteDefinition get notes => _notes;
  RouteDefinition get dashboard => _dashboard;
  RouteDefinition get list => _list;

  final List<RouteDefinition> all = [
    new RouteDefinition.redirect(path: '', redirectTo: notesPath.toUrl()),
    _notes,
    _notesId,
    _list,
    _dashboard
  ];
}