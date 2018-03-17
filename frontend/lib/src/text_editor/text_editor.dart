import 'dart:html' as html;

import 'package:angular/core.dart';
import 'package:frontend/src/text_editor/text_editor_wrapper.dart';


@Component(
    selector: 'text-editor',
    styleUrls: const <String>['text_editor.css'],
    templateUrl: 'text_editor.html',
    directives: const <Object>[]
)
class TextEditorComponent implements AfterViewInit {

  TextEditorWrapper _editorWrapper;

  @ViewChild('editableDiv') html.DivElement editableDiv;


  void bClick() {
    _editorWrapper.bold();
  }

  void iClick() {
    _editorWrapper.italic();
  }

  void bgColorClick() {
    _editorWrapper.bgColor('red');
  }

  void underlineClick() {
    _editorWrapper.underline();
  }

  void strikeClick() {
    _editorWrapper.strike();
  }

  void subClick() {
    _editorWrapper.sub();
  }

  void supClick() {
    _editorWrapper.sup();
  }


  void foreColorClick() {
    _editorWrapper.foreColor('red');
  }

  void linkClick() {
    _editorWrapper.link('google.com');
  }

  void smallClick() {
    _editorWrapper.small();
  }

  void wrapClick() {
    _editorWrapper.block();
  }

  void intendClick() {
    _editorWrapper.intend();
  }

  void outdentClick() {
    _editorWrapper.outdent();
  }

  void olClick() {
    _editorWrapper.ol();
  }

  void ulClick() {
    _editorWrapper.ul();
  }

  void clearClick() {
    _editorWrapper.clearFormatting();
  }





  @override
  void ngAfterViewInit() {
    _editorWrapper = new TextEditorWrapper(editableDiv);
  }
}