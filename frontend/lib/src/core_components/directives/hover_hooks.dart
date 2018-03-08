import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:list/src/core_components/common/subscriptions.dart';


/// Provides ability to add CSS classes on
///  element, when it hovered
///  with key pressed
@Directive(selector: '[hover-hooks]')
class HoverHooks implements OnDestroy {
  /// Constants describes different element states
  static const String Meta = 'meta';
  static const String Alt = 'alt';

  final Subscriptions _subs = new Subscriptions();
  final Subscriptions _tmpSubs = new Subscriptions();
  final html.Element _el;
  final NgZone _zone;

  String _clazz;
  String _altClazz;
  String _metaClazz;


  HoverHooks(this._el, this._zone) {
    _zone.runOutsideAngular(() {
      _subs
        ..listen(_el.onMouseEnter, _mouseEnter)
        ..listen(_el.onMouseLeave, _mouseLeave);
    });

//    // To debug:
//    new html.MutationObserver((records, o) {
//      for(var r in records) {
//        print('${r.attributeName} : ${_el.getAttribute(r.attributeName)}');
//      }
//    }).observe(_el, attributes: true);
  }


  @Input('hover-hooks') set cssClass(String value) {
    _clazz = value;
    _altClazz = '$value-$Alt';
    _metaClazz = '$value-$Meta';
  }

  String get cssClass => _clazz;


  @override
  void ngOnDestroy() {
    _tmpSubs.cancel();
    _subs.cancel();
  }

  void _mouseEnter(html.MouseEvent event) {
    NgZone.assertNotInAngularZone();

    _tmpSubs.listen(_el.ownerDocument.onKeyDown, _keyDown);
    _tmpSubs.listen(_el.ownerDocument.onKeyUp, _keyUp);

    _el.classes.add(_clazz);
    if(event.altKey) _el.classes.add(_altClazz);
    if(event.metaKey || event.ctrlKey) _el.classes.add(_metaClazz);
  }

  void _mouseLeave(html.MouseEvent event) {
    NgZone.assertNotInAngularZone();

    _tmpSubs.cancel();
    _tmpSubs.clear();

    _el.classes.removeAll(<String>[_clazz, _altClazz, _metaClazz]);
  }

  void _keyDown(html.KeyboardEvent event) {
    NgZone.assertNotInAngularZone();

    if(event.altKey) _el.classes.add(_altClazz);
    if(event.metaKey || event.ctrlKey) _el.classes.add(_metaClazz);
  }

  void _keyUp(html.KeyboardEvent event) {
    NgZone.assertNotInAngularZone();

    if(!event.altKey) _el.classes.remove(_altClazz);
    if(!event.metaKey && !event.ctrlKey) _el.classes.remove(_metaClazz);
  }
}