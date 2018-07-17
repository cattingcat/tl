import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/editable_text/editable_text.dart';
import 'package:frontend/src/lorem.dart';
import 'package:frontend/src/text_editor/text_editor.dart';

@Component(
    selector: 'task-view',
    styleUrls: const <String>['task_view.css'],
    templateUrl: 'task_view.html',
    directives: const <Object>[EditableTextComponent, TextEditorComponent],
    changeDetection: ChangeDetectionStrategy.OnPush)
class TaskViewComponent {
  TitleModel titleModel;
  bool isDescriptionEditable = false;
  String taskDescription = loremHtml;

  TaskViewComponent() {
    titleModel = new TitleModel('Hello from task view');
  }

  void onToggleEditMode() {
    isDescriptionEditable = !isDescriptionEditable;
  }

  void onDescriptionChanged(String newDescription) {
    print(newDescription);
  }
}
