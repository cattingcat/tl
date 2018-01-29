import 'package:angular/angular.dart';
import 'package:list/src/core_components/directives/hover_hooks.dart';
import 'package:list/src/core_components/editable_title/editable_title.dart';
import 'package:list/src/core_components/editable_title/title_model.dart';
import 'package:list/src/task_list/core/task_list_model.dart';

@Component(
  selector: 'task-card',
  styleUrls: const <String>['task_card_component.scss.css'],
  templateUrl: 'task_card_component.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    HoverHooks,
    EditableTitle
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskCardComponent implements AfterViewInit, OnChanges {
  @Input() TaskListModel model;


  TitleModel titleModel;

  @override
  void ngAfterViewInit() {}

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    titleModel = new TitleModel(model.text);
  }
}