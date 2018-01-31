import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:list/src/core_components/editable_title/title_model.dart';

@Component(
    selector: 'editable-title',
    styleUrls: const <String>['editable_title.scss.css'],
    templateUrl: 'editable_title.html',
    directives: const <Object>[
      CORE_DIRECTIVES
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class EditableTitle {
  bool _isEditable = false;


  @Input('model') TitleModel model;

  @ViewChild('titleInput') ElementRef titleInput;

  void titleDbClick(html.MouseEvent event) {
    _isEditable = true;
    titleInputEl.attributes.remove('readonly');


    titleInputEl.focus();
  }

  void submitClick(html.MouseEvent event) {
    _isEditable = false;
    titleInputEl.setAttribute('readonly', 'true');
  }

  bool get isEditable => _isEditable;


  html.InputElement get titleInputEl => titleInput.nativeElement as html.InputElement;
}

