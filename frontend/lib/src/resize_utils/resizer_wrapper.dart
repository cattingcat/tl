import 'dart:async';
import 'dart:html' as html;

class ResizerWrapper {
  final _moveCtrl = new StreamController<html.MouseEvent>(sync: true);
  final _mouseupCtrl = new StreamController<html.MouseEvent>(sync: true);
  final html.Element _resizerEl;
  bool _resizing = false;

  ResizerWrapper(this._resizerEl) {
    html.document
      ..addEventListener('mouseup', _handleMouseUp, false)
      ..addEventListener('mousemove', _mouseMove, false);

    _resizerEl.addEventListener('mousedown', _handleMouseDown, false);
  }

  Stream<html.MouseEvent> get onResizing => _moveCtrl.stream;

  Stream<html.MouseEvent> get onFinish => _mouseupCtrl.stream;

  void destroy() {
    html.document
      ..removeEventListener('mouseup', _handleMouseUp, false)
      ..removeEventListener('mousemove', _mouseMove, false);

    _resizerEl.removeEventListener('mousedown', _handleMouseDown, false);
  }


  void _handleMouseUp(html.MouseEvent event) {
    if(_resizing) _mouseupCtrl.add(event);

    _resizing = false;
  }

  void _handleMouseDown(html.MouseEvent event) {
    _resizing = true;
  }

  void _mouseMove(html.MouseEvent event) {
    if(_resizing) _moveCtrl.add(event);
  }
}