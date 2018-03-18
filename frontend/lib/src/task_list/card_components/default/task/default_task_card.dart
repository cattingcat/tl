import 'dart:async';
import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/directives/hover_hooks.dart';
import 'package:frontend/src/core_components/editable_text/editable_text.dart';
import 'package:frontend/src/core_components/editable_text/text_model.dart';
import 'package:frontend/src/core_components/single_avatar/single_avatar.dart';
import 'package:frontend/src/core_components/tag_list/tag_list.dart';
import 'package:frontend/src/core_components/tag_list/tag_model.dart';
import 'package:frontend/src/task_list/card_components/mouse_card_event.dart';
import 'package:frontend/src/task_list/card_components/task_card_observer.dart';
import 'package:frontend/src/task_list/card_components/title_change_card_event.dart';
import 'package:frontend/src/task_list/card_components/toggle_card_event.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';


@Component(
  selector: 'default-task-card',
  styleUrls: const <String>['default_task_card.css'],
  templateUrl: 'default_task_card.html',
  directives: const <Object>[
    HoverHooks,
    EditableTextComponent,
    SingleAvatarComponent,
    TagListComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class DefaultTaskCard implements OnChanges {
  final html.Element _hostEl;

  DefaultTaskCard(this._hostEl);


  @Input() TaskListViewModel model;
  @Input() TaskCardObserver observer;

  TitleModel titleModel;
  String avatarUri = 'https://avatars1.githubusercontent.com/u/5341725?v=4';


  bool get isExpandable => model.model.children.isNotEmpty;

  bool get isExpanded => model.model.isExpanded;

  Iterable<TagModel> tags = [new TagModel('123'), new TagModel('qwe'),new TagModel('asd'),new TagModel('zxc xcvxcv')];

  void onTitleChange(String title) {
    Zone.ROOT.run(() {
      final event = new TitleChangeCardEvent(model.model, title);
      observer.titleChange(event);
    });
  }

  void onExpanderClick(html.MouseEvent event) {
    event.stopPropagation();

    Zone.ROOT.run(() {
      final event = new ToggleCardEvent(model.model, !model.model.isExpanded);
      observer.toggle(event);
    });
  }

  @HostListener('click', const ['\$event'])
  void onHostClick (html.MouseEvent event) {
    Zone.ROOT.run(() {
      final e = new MouseCardEvent(model.model, event, _hostEl);
      observer.click(e);
    });
  }

  @HostListener('mouseenter', const ['\$event'])
  void onHostMouseEnter (html.MouseEvent event) {
    Zone.ROOT.run(() {
      final e = new MouseCardEvent(model.model, event, _hostEl);
      observer.onMouseEnter(e);
    });
  }

  @HostListener('mouseleave', const ['\$event'])
  void onHostMouseLeave (html.MouseEvent event) {
    Zone.ROOT.run(() {
      final e = new MouseCardEvent(model.model, event, _hostEl);
      observer.onMouseLeave(e);
    });
  }

  @HostListener('mousemove', const ['\$event'])
  void onHostMouseMove (html.MouseEvent event) {
    Zone.ROOT.run(() {
      final e = new MouseCardEvent(model.model, event, _hostEl);
      observer.onMouseMove(e);
    });
  }


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    titleModel = new TitleModel(model.toString());
  }
}