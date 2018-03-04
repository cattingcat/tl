import 'dart:html' as html;

import 'package:angular/core.dart';
import 'package:list/src/core_components/dnd/drop_target_observer.dart';


@Directive(selector: '[drop-target]')
class DropTarget implements OnDestroy {
  final html.Element _host;

  @Input('drop-target') DropTargetObserver observer;

  DropTarget(this._host) {
    _host
      ..addEventListener('drop', _onDrop, false)
      ..addEventListener('dragenter', _onDragEnter, false)
      ..addEventListener('dragleave', _onDragLeave, false)
      ..addEventListener('dragover', _onDragOver, false);
  }


  @override
  void ngOnDestroy() {
    _host
      ..removeEventListener('drop', _onDrop, false)
      ..removeEventListener('dragenter', _onDragEnter, false)
      ..removeEventListener('dragleave', _onDragLeave, false)
      ..removeEventListener('dragover', _onDragOver, false);
  }


  void _onDrop(html.MouseEvent event) {
    NgZone.assertNotInAngularZone();
    event.preventDefault();

    observer.onDrop(event);
  }

  void _onDragEnter(html.MouseEvent event) {
    NgZone.assertNotInAngularZone();
    event.preventDefault();

    observer.onDragEnter(event);
  }

  void _onDragLeave(html.MouseEvent event) {
    NgZone.assertNotInAngularZone();
    event.preventDefault();

    observer.onDragLeave(event);
  }

  void _onDragOver(html.MouseEvent event) {
    event.preventDefault();

    observer.onDragOver(event);
  }
}