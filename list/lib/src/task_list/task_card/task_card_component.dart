import 'package:angular/angular.dart';
import 'package:list/src/core_components/directives/hover_hooks.dart';
import 'package:list/src/core_components/editable_title/editable_text.dart';
import 'package:list/src/core_components/editable_title/text_model.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

@Component(
  selector: 'task-card',
  styleUrls: const <String>['task_card_component.scss.css'],
  templateUrl: 'task_card_component.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    HoverHooks,
    EditableText
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskCardComponent implements AfterViewInit, OnChanges {
  @Input() TaskListViewModel model;


  TitleModel titleModel;

  @override
  void ngAfterViewInit() {}

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    titleModel = new TitleModel(model.text);
  }
}