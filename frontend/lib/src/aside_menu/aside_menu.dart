import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/collapsable_container/collapsible_container.dart';
import 'package:frontend/src/core_components/common/subscriptions.dart';
import 'package:frontend/src/resize_utils/resizer_wrapper.dart';

@Component(
    selector: 'aside-menu',
    styleUrls: const <String>['aside_menu.css'],
    templateUrl: 'aside_menu.html',
    directives: const <Object>[
      NgFor,
      NgIf,
      CollapsibleContainerComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class AsideMenuComponent implements AfterViewInit, OnDestroy {
  static const int _MaxWidth = 350;
  static const int _MinWidth = 150;
  final Subscriptions _subscr = new Subscriptions();
  final _pinCtrl = new StreamController<bool>(sync: true);
  final html.Element _hostEl;
  ResizerWrapper _resizer;

  bool isPined = false;

  AsideMenuComponent(this._hostEl);


  @Output() Stream<bool> get onPin => _pinCtrl.stream;

  @ViewChild('resizer') html.Element resizerEl;


  void onPinHandle() {
    isPined = !isPined;
    _pinCtrl.add(isPined);
  }


  @override
  void ngAfterViewInit() {
    _resizer = new ResizerWrapper(resizerEl);
    Zone.root.run(() {
      _subscr.listen(_resizer.onResizing, _onResize);
    });
  }

  @override
  void ngOnDestroy() {
    _subscr.cancelClear();
    _resizer.destroy();
  }


  void _onResize(html.MouseEvent event) {
    final w = _hostEl.clientWidth;
    final newW = w + event.movement.x;

    if(newW > _MaxWidth) {
      _hostEl.style.width = '${_MaxWidth}px';
    } else if(newW < _MinWidth) {
      _hostEl.style.width = '${_MinWidth}px';
    } else {
      _hostEl.style.width = '${newW}px';
    }
  }
}
