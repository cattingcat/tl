import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/common/subscriptions.dart';
import 'package:frontend/src/resize_utils/resizer_wrapper.dart';

@Component(
    selector: 'vsplit-container',
    styleUrls: const <String>['vsplit_container.css'],
    templateUrl: 'vsplit_container.html',
    directives: const <Object>[
      NgFor,
      NgIf
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class VsplitContainer implements AfterViewInit, OnDestroy {
  static const int _SeparatorWDiv2 = 1;
  static const String _HiddenClass = 'hidden';
  final Subscriptions _subscr = new Subscriptions();
  final html.Element _hostEl;
  int _separatorPosition = 0;
  ResizerWrapper _resizer;

  VsplitContainer(this._hostEl);


  @ViewChild('leftContainer') html.Element leftEl;
  @ViewChild('rightContainer') html.Element rightEl;
  @ViewChild('separator') html.Element separatorEl;

  int leftMinWidthPx = 350;
  int rightMinWidthPx = 100;
  int leftWidth = 50;
  int rightWidth = 50;
  bool allowResize = true;


  @override
  void ngAfterViewInit() {
    if(allowResize) {
      _hostEl
        ..addEventListener('mouseenter', _mouseEnter, false)
        ..addEventListener('mouseleave', _mouseLeave, false);

      _resizer = new ResizerWrapper(separatorEl);

      Zone.root.run(() {
        _subscr
          ..listen(_resizer.onResizing, _mouseMove)
          ..listen(_resizer.onFinish, _handleMouseUp);
      });
    }

    _setLeftPercent(leftWidth);
  }

  @override
  void ngOnDestroy() {
    _subscr.cancelClear();
    _hostEl
      ..removeEventListener('mouseenter', _mouseEnter, false)
      ..removeEventListener('mouseleave', _mouseLeave, false);

    _resizer?.destroy();
  }




  void _handleMouseUp(html.MouseEvent event) {
    final width = _hostEl.clientWidth;
    final leftPercent = (((_separatorPosition + _SeparatorWDiv2) / width) * 100).floor();

    _setLeftPercent(leftPercent);
  }


  void _mouseEnter(html.MouseEvent event) {
    _refreshSeparator();
    separatorEl.classes.remove(_HiddenClass);
  }

  void _mouseLeave(html.MouseEvent event) {
    separatorEl.classes.add(_HiddenClass);
  }


  void _mouseMove(html.MouseEvent event) {
    NgZone.assertNotInAngularZone();

    final positionPretender = _separatorPosition + event.movement.x;
    final width = _hostEl.clientWidth;

    // Don't allow to move outside bounds
    if(positionPretender < leftMinWidthPx
        || positionPretender > width - rightMinWidthPx) return;

    _separatorPosition += event.movement.x;
    _setSeparatorPos(_separatorPosition);
  }


  void _setLeftPercent(int leftPercent) {
    leftWidth = leftPercent;
    rightWidth = 100 - leftWidth;

    leftEl.style.width = '${leftWidth}%';
    rightEl.style.width = '${rightWidth}%';

    _refreshSeparator();
  }

  void _refreshSeparator() {
    _separatorPosition = leftEl.clientWidth; // clientWidth doesn't calculate borders
    _setSeparatorPos(_separatorPosition);
  }

  void _setSeparatorPos(int x) {
    separatorEl.style.transform = 'translateX(${x}px)';
  }
}
