import 'dart:html' as html;


class TextEditorWrapper {
  final html.DivElement _el;

  TextEditorWrapper(this._el);

  void bold() {
    html.document.execCommand('bold');
  }

  void italic() {
    html.document.execCommand('italic');
  }

  void strike() {
    html.document.execCommand('strikeThrough');
  }

  void underline() {
    html.document.execCommand('underline');
  }

  void sub() {
    html.document.execCommand('subscript');
  }

  void sup() {
    html.document.execCommand('superscript');
  }


  void bgColor(String color) {
    html.document.execCommand('backColor', false, color);
  }

  void foreColor(String color) {
    html.document.execCommand('foreColor', false, color);
  }

  void link(String href) {
    html.document.execCommand('createLink', false, href);
  }

  void small() {
    html.document.execCommand('fontSize', false, '1');
  }

  void block() {
    // replace DIV tag with specified tag for whole block
    html.document.execCommand('formatBlock', false, 'H1');
  }

  void intend() {
    // wraps block with blockquote tag
    html.document.execCommand('indent', false);
  }

  void outdent() {
    // wraps block with blockquote tag
    html.document.execCommand('outdent', false);
  }

  void ol() {
    html.document.execCommand('insertOrderedList');
  }

  void ul() {
    html.document.execCommand('insertUnorderedList');
  }

  void clearFormatting() {
    html.document.execCommand('removeFormat');
  }


  // TODO: document.queryCommandValue('italic') = "true"   - check button enabled/disabled
  // TODO: insertHTML, insertImage, insertText
  // TODO: justifyCenter, justifyFull, justifyLeft, justifyRight
}