import 'dart:html' as html;


class ViewportElement {
  final html.Element _viewportElement;
  int _offset = 0;

  ViewportElement(this._viewportElement);


  int get offset => _offset;

  set offset(int value) {
    _offset = value;
    _viewportElement.style.transform = 'translate(0px, ${value}px)';
  }
}
