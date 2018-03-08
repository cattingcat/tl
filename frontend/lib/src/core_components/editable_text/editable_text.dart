import 'dart:async';
import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:list/src/core_components/editable_text/text_model.dart';

@Component(
    selector: 'editable-text',
    styleUrls: const <String>['editable_text.css'],
    templateUrl: 'editable_text.html',
    directives: const <Object>[NgIf],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class EditableText {
  final _ctrl = new StreamController<String>.broadcast(sync: true);
  bool _isEditable = false;

  @Input('model') TitleModel model;
  @Output('change') Stream<String> get change => _ctrl.stream;

  @ViewChild('textInput') html.InputElement textInput;


  bool get isEditable => _isEditable;

  void inputDbClick(html.MouseEvent event) {
    _isEditable = true;
    textInput.attributes.remove('readonly');

    // Place cursor into input
    textInput.selectionStart = textInput.selectionEnd = 10000;
  }

  void inputBlur(html.Event event) {
    if(isEditable) _submit();
  }

  void submitClick(html.MouseEvent event) => _submit();

  void formSubmit(html.Event event) {
    event.preventDefault();
  }

  void _submit() {
    _isEditable = false;
    textInput.setAttribute('readonly', 'true');

    final newText = textInput.value;

    if(model.text != newText) _ctrl.add(newText);
  }
}

