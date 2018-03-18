import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/editable_text/editable_text.dart';
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
  String taskDescription = '''
<h3>  Lorem ipsum&nbsp;</h3><blockquote style="margin: 0 0 0 40px; border: none; padding: 0px;"><div>dolor sit amet, consectetur 
  adipiscing elit, sed&nbsp;</div></blockquote><div><br></div><div><ol><li>do eiusmod tempor 
  incididunt ut labore et&nbsp;<br></li><li>dolore magna aliqua. 
  Ut enim ad minim v<br></li></ol></div><div><ul><li>eniam, quis nostrud 
  exercitation ullamco<br></li><li>&nbsp;laboris nisi ut aliquip 
  ex ea commodo cons<br></li></ul></div><div><b>equat</b>. Duis aute <sub>irure</sub> dolor
   in <sup>reprehenderit</sup></div><div>&nbsp;in <i>voluptate</i> velit esse cillum
    dolore eu fugiat&nbsp;</div><div>nulla pariatur. <u>Excepteur</u> 
    sint <strike>occaecat</strike> cupid</div><div>atat non <font size="5">proident</font>, sunt 
    in culpa qui officia d</div><div>eserunt <font color="#008000">mollit</font> anim 
    id est <span style="background-color: yellow;">laborum</span>.
  </div>
  ''';

  TaskViewComponent() {
    titleModel = new TitleModel('Hello from task view');
  }

  void onToggleEditMode() {
    isDescriptionEditable = !isDescriptionEditable;
  }

  void onDescriptionChanged(String newDescr) {
    print(newDescr);
  }
}
