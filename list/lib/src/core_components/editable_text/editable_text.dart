import 'dart:async';
import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:list/src/core_components/editable_text/text_model.dart';

@Component(
    selector: 'editable-text',
    styleUrls: const <String>['editable_text.css'],
    templateUrl: 'editable_text.html',
    directives: CORE_DIRECTIVES,
    changeDetection: ChangeDetectionStrategy.OnPush
)
class EditableText {
  final _ctrl = new StreamController<String>.broadcast(sync: true);
  bool _isEditable = false;

  @Input('model') TitleModel model;
  @Output('change') Stream<String> get change => _ctrl.stream;

  @ViewChild('textInput') ElementRef textInput;


  bool get isEditable => _isEditable;

  void inputDbClick(html.MouseEvent event) {
    _isEditable = true;
    _textInputEl.attributes.remove('readonly');

    // Place cursor into input
    _textInputEl.selectionStart = _textInputEl.selectionEnd = 10000;
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
    _textInputEl.setAttribute('readonly', 'true');

    final newText = _textInputEl.value;

    if(model.text != newText) _ctrl.add(newText);
  }

  html.InputElement get _textInputEl => textInput.nativeElement as html.InputElement;
}

