import 'dart:async';

import 'package:angular/angular.dart';

@Component(
    selector: 'overlay',
    styleUrls: const <String>['overlay.css'],
    templateUrl: 'overlay.html',
    directives: const <Object>[],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class OverlayComponent {
  final StreamController<void> _closeController = new StreamController<void>(sync: true);

  @Output()
  Stream<void> get close => _closeController.stream;

  void onClickOutside() {
    _closeController.add(null);
  }
}
