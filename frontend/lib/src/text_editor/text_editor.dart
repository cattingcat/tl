import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/text_editor/block_edit_panel/block_edit_panel.dart';
import 'package:frontend/src/text_editor/selection_edit_panel/selection_edit_panel.dart';
import 'package:frontend/src/text_editor/text_editor_wrapper.dart';


@Component(
    selector: 'text-editor',
    styleUrls: const <String>['text_editor.css'],
    templateUrl: 'text_editor.html',
    directives: const <Object>[
      NgIf,
      BlockEditPanelComponent,
      SelectionEditPanelComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TextEditorComponent implements AfterViewInit {
  TextEditorWrapper _editorWrapper;

  @Input() bool isEditable = false;

  @ViewChild('editableDiv') html.DivElement editableDiv;

  bool showSelectionTools = false;
  String selectionToolsTop = '0';
  String selectionToolsLeft = '0';

  void onMouseUp() {
    showSelectionTools = false;
    if(!isEditable) return;

    final selection = html.window.getSelection();

    if(!selection.isCollapsed && editableDiv.contains(selection.anchorNode)) {
      final range = selection.getRangeAt(0);
      final clientRect = range.getBoundingClientRect();

      final hostRect = editableDiv.getBoundingClientRect();

      final selectionRect = new html.Rectangle(
          clientRect.left - hostRect.left,
          clientRect.top - hostRect.top,
          clientRect.width,
          clientRect.height);

      selectionToolsTop = '${selectionRect.top + selectionRect.height}px';
      selectionToolsLeft = '${selectionRect.left}px';
      showSelectionTools = true;
    }
  }

  void onBoldClick() => _editorWrapper.bold();
  void onItalicClick() => _editorWrapper.italic();
  void onUnderlineClick() => _editorWrapper.underline();
  void onStrikeClick() => _editorWrapper.strike();
  void onSubClick() => _editorWrapper.sub();
  void onSupClick() => _editorWrapper.sup();
  void onFontSizePick(int size) => _editorWrapper.fontSize(size);
  void onBackgroundPick(String color) => _editorWrapper.bgColor(color);
  void onForegroundPick(String color) => _editorWrapper.foreColor(color);
  void onClearClick() => _editorWrapper.clearFormatting();

  void onHeadingClick(int level) {
    if(level == 0) {
      _editorWrapper.block('DIV');
    } else {
      final tag = 'H$level';
      _editorWrapper.block(tag);
    }
  }

  void onIntendClick(bool isAdd) {
    if(isAdd) {
      _editorWrapper.intend();
    } else {
      _editorWrapper.outdent();
    }
  }

  void onOlClick() => _editorWrapper.ol();
  void onUlClick() => _editorWrapper.ul();

  @override
  void ngAfterViewInit() {
    _editorWrapper = new TextEditorWrapper(editableDiv);
  }
}