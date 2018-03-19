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
  static const int _SeparatorWDiv2 = 2;
  final Subscriptions _subscr = new Subscriptions();
  final html.Element _hostEl;
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
      _resizer = new ResizerWrapper(separatorEl);

      Zone.root.run(() {
        _subscr
          ..listen(_resizer.onResizing, _mouseMove)
          ..listen(_resizer.onFinish, _handleMouseUp);
      });
    }
  }

  @override
  void ngOnDestroy() {
    _subscr.cancelClear();
    _resizer?.destroy();
  }


  int _movement = -1;

  void _handleMouseUp(html.MouseEvent event) {
    final width = _hostEl.clientWidth;
    final leftPercent = (((_movement + _SeparatorWDiv2) / width) * 100).floor();

    print(leftPercent);

    _setLeftPercent(leftPercent);
    _movement = -1;
  }

  void _mouseMove(html.MouseEvent event) {
    NgZone.assertNotInAngularZone();

    if(_movement == -1) {
      _movement = leftEl.clientWidth + _SeparatorWDiv2;
    }

    final positionPretender = _movement + event.movement.x;
    final width = _hostEl.clientWidth;

    // Don't allow to move outside bounds
    if(positionPretender < leftMinWidthPx
        || positionPretender > width - rightMinWidthPx) return;

    _movement = positionPretender;
  }


  void _setLeftPercent(int leftPercent) {
    leftWidth = leftPercent;
    rightWidth = 100 - leftWidth;

    leftEl.style.width = 'calc(${leftWidth}% - 2px)';
    rightEl.style.width = 'calc(${rightWidth}% - 2px)';
  }
}
