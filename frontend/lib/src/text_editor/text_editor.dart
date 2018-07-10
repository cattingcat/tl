import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/text_editor/block_edit_panel/block_edit_panel.dart';
import 'package:frontend/src/text_editor/safe_html.dart';
import 'package:frontend/src/text_editor/selection_edit_panel/selection_edit_panel.dart';
import 'package:frontend/src/text_editor/text_editor_wrapper.dart';
import 'package:rxdart/transformers.dart';


@Component(
    selector: 'text-editor',
    styleUrls: const <String>['text_editor.css'],
    templateUrl: 'text_editor.html',
    directives: const <Object>[
      NgIf,
      BlockEditPanelComponent,
      SelectionEditPanelComponent
    ],
    pipes: const <Object>[SafeHtmlPipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TextEditorComponent implements AfterViewInit, OnDestroy {
  static const Duration _debounceEventDuration = const Duration(seconds: 1);
  final _changeCtrl = new StreamController<String>(sync: true);
  final ChangeDetectorRef _cdr;
  final html.Element _hostEl;
  TextEditorWrapper _editorWrapper;

  TextEditorComponent(this._hostEl, this._cdr);

  @Input() bool isEditable = false;
  @Input() String placeholder = 'Empty...';
  @Input() String initialHtml = '';

  @Output() Stream<String> get contentChanged {
    final transform = new DebounceStreamTransformer<String>(_debounceEventDuration);
    return _changeCtrl.stream.transform(transform);
  }


  bool showSelectionTools = false;
  String selectionToolsTop = '0';
  String selectionToolsLeft = '0';

  @HostListener('focus')
  void onFocus() => _editableDiv.focus();

  void onMouseUp() {
    showSelectionTools = false;
    if(!isEditable) return;

    final selection = html.window.getSelection();

    if(!selection.isCollapsed && _editableDiv.contains(selection.anchorNode)) {
      _updateToolsMenuCoords(selection);
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
    _editorWrapper = new TextEditorWrapper(_editableDiv);
    html.document.addEventListener('selectionchange', _onSelectionChange, false);

    _hostEl.addEventListener("mouseup", _onContentChange, false);
    _editableDiv
      ..addEventListener("blur", _onContentChange, false)
      ..addEventListener("keyup", _onContentChange, false)
      ..addEventListener("paste", _onContentChange, false)
      ..addEventListener("copy", _onContentChange, false)
      ..addEventListener("cut", _onContentChange, false)
      ..addEventListener("delete", _onContentChange, false);
  }

  @override
  void ngOnDestroy() {
    html.document.removeEventListener('selectionchange', _onSelectionChange, false);

    _hostEl.removeEventListener("mouseup", _onContentChange, false);
    _editableDiv
      ..removeEventListener("blur", _onContentChange, false)
      ..removeEventListener("keyup", _onContentChange, false)
      ..removeEventListener("paste", _onContentChange, false)
      ..removeEventListener("copy", _onContentChange, false)
      ..removeEventListener("cut", _onContentChange, false)
      ..removeEventListener("delete", _onContentChange, false);
  }


  void _onSelectionChange(html.Event _) {
    final selection = html.window.getSelection();

    if(isEditable) {
      if (showSelectionTools && (selection.isCollapsed || !_editableDiv.contains(selection.anchorNode))) {
        showSelectionTools = false;
        _update();
      }

      if (!showSelectionTools && !selection.isCollapsed && _editableDiv.contains(selection.anchorNode)) {
        _updateToolsMenuCoords(selection);
        showSelectionTools = true;
        _update();
      }
    }
  }

  void _onContentChange(html.Event _) {
    NgZone.assertNotInAngularZone();
    if(!isEditable) return;

    new Future<Null>.delayed(const Duration(milliseconds: 100)).then((_) {
      _changeCtrl.add(_editableDiv.innerHtml);
    });
  }

  void _updateToolsMenuCoords(html.Selection selection) {
    final range = selection.getRangeAt(0);
    final clientRect = range.getBoundingClientRect();

    final hostRect = _editableDiv.getBoundingClientRect();

    final selectionRect = new html.Rectangle(
        clientRect.left - hostRect.left,
        clientRect.top - hostRect.top,
        clientRect.width,
        clientRect.height);

    selectionToolsTop = '${selectionRect.top + selectionRect.height}px';
    selectionToolsLeft = '${selectionRect.left}px';
  }

  /*can't use @ViewChild('editableDiv') because of recycling*/
  html.DivElement get _editableDiv => _hostEl.querySelector('.editable-block');

  void _update() {
    _cdr
      ..markForCheck()
      ..detectChanges();
  }
}