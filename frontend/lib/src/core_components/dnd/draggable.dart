import 'dart:html' as html;

import 'package:angular/core.dart';
import 'package:frontend/src/core_components/dnd/dnd.dart';


@Directive(selector: '[draggable]')
class Draggable implements OnDestroy {
  final html.Element _host;

  @Input('draggable') Object data;

  Draggable(this._host) {
    _host
      ..setAttribute('draggable', 'true')
      ..addEventListener('dragstart', _onDragStart, false)
      ..addEventListener('dragend', _onDragEnd, false);
  }


  @override
  void ngOnDestroy() {
    _host
      ..removeEventListener('dragstart', _onDragStart, false)
      ..removeEventListener('dragend', _onDragEnd, false);
  }


  void _onDragStart(html.Event event) {
    NgZone.assertNotInAngularZone();

    final node = _host.clone(true);
    final ghostContainer = _getGhostContainer();
    ghostContainer.append(node);

    final mouseEvent = event as html.MouseEvent;
    mouseEvent.dataTransfer.setDragImage(node, 0, 0);
    mouseEvent.dataTransfer.setData(Dnd.ObjectId, 'See Dnd.dataTransfer');
    Dnd.dataTransfer = data;
  }

  void _onDragEnd(html.Event event) {
    NgZone.assertNotInAngularZone();

    final ghostContainer = _getGhostContainer();
    ghostContainer.firstChild?.remove();

    Dnd.dataTransfer = null;
  }


  html.Node _getGhostContainer() {
    final container = html.document.querySelector('#${Dnd.GhostItemContainerId}');
    if(container != null) return container;


    final dndContainer = new html.Element.div();
    dndContainer.id = Dnd.GhostItemContainerId;
    dndContainer.style
      ..position = 'fixed'
      ..top = '-100px'
      ..left = '0px';


    html.document.body.append(dndContainer);

    return dndContainer;
  }
}