import 'dart:async';
import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/directives/hover_hooks.dart';
import 'package:frontend/src/core_components/editable_text/editable_text.dart';
import 'package:frontend/src/core_components/editable_text/text_model.dart';
import 'package:frontend/src/core_components/single_avatar/single_avatar.dart';
import 'package:frontend/src/core_components/tag_list/tag_list.dart';
import 'package:frontend/src/task_list/card_components/mouse_card_event.dart';
import 'package:frontend/src/task_list/card_components/task_card_observer.dart';
import 'package:frontend/src/task_list/card_components/title_change_card_event.dart';
import 'package:frontend/src/task_list/card_components/toggle_card_event.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';


@Component(
    selector: 'default-group-card',
    styleUrls: const <String>['default_group_card.css'],
    templateUrl: 'default_group_card.html',
    directives: const <Object>[],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class DefaultGroupCard {
  @Input() TaskListViewModel model;
  @Input() TaskCardObserver observer;


  String get title => model.model.toString();

  bool get isExpandable => model.model.children.isNotEmpty;

  bool get isExpanded => model.model.isExpanded;

  void onExpanderClick(html.MouseEvent event) {
    event.stopPropagation();

    Zone.root.run(() {
      final event = new ToggleCardEvent(model.model, !model.model.isExpanded);
      observer.toggle(event);
    });
  }
}