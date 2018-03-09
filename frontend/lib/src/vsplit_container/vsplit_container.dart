import 'dart:html' as html;

import 'package:angular/angular.dart';

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
  final html.Element _hostEl;
  bool _resizing = false;
  int _separatorPosition = 0;

  VsplitContainer(this._hostEl);


  @ViewChild('leftContainer') html.Element leftEl;
  @ViewChild('rightContainer') html.Element rightEl;
  @ViewChild('separator') html.Element separatorEl;

  int leftMinWidthPx = 100;
  int rightMinWidthPx = 100;
  int leftWidth = 50;
  int rightWidth = 50;
  bool allowResize = true;


  @override
  void ngAfterViewInit() {
    if(allowResize) {
      html.document.body.addEventListener('mouseup', _handleMouseUp, false);

      _hostEl..addEventListener(
          'mousemove', _mouseMove, false)..addEventListener(
          'mouseenter', _mouseEnter, false)..addEventListener(
          'mouseleave', _mouseLeave, false);

      separatorEl.addEventListener('mousedown', _handleMouseDown, false);
    }

    _setLeftPercent(leftWidth);
  }

  @override
  void ngOnDestroy() {
    html.document.body.removeEventListener('mouseup', _handleMouseUp, false);

    _hostEl
      ..removeEventListener('mousemove', _mouseMove, false)
      ..removeEventListener('mouseenter', _mouseEnter, false)
      ..removeEventListener('mouseleave', _mouseLeave, false);

    separatorEl.removeEventListener('mousedown', _handleMouseDown, false);
  }


  void _handleMouseDown(html.MouseEvent event) {
    _resizing = true;
  }

  void _handleMouseUp(html.MouseEvent event) {
    if(_resizing) {
      final width = _hostEl.clientWidth;
      final leftPercent = (((_separatorPosition + _SeparatorWDiv2) / width) * 100).floor();

      _setLeftPercent(leftPercent);
    }

    _resizing = false;
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

    if(_resizing) {
      final positionPretender = _separatorPosition + event.movement.x;
      final width = _hostEl.clientWidth;

      // Don't allow to move outside bounds
      if(positionPretender < leftMinWidthPx
          || positionPretender > width - rightMinWidthPx) return;

      _separatorPosition += event.movement.x;
      _setSeparatorPos(_separatorPosition);
    }
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
