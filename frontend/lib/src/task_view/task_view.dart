import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/editable_text/editable_text.dart';
import 'package:frontend/src/text_editor/block_edit_panel/block_edit_panel.dart';
import 'package:frontend/src/text_editor/selection_edit_panel/selection_edit_panel.dart';
import 'package:frontend/src/text_editor/text_editor.dart';
import 'package:frontend/src/text_editor/text_editor_wrapper.dart';


@Component(
    selector: 'task-view',
    styleUrls: const <String>['task_view.css'],
    templateUrl: 'task_view.html',
    directives: const <Object>[
      EditableTextComponent,
      TextEditorComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskViewComponent {
  TitleModel titleModel;
  bool isDescriptionEditable = false;

  TaskViewComponent() {
    titleModel = new TitleModel('Hello from task view');
  }


  void onToggleEditMode() {
    isDescriptionEditable = !isDescriptionEditable;
  }
}