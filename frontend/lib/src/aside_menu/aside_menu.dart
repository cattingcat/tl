import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/app_header/header_events.dart';
import 'package:frontend/src/app_header/item_model.dart';
import 'package:frontend/src/app_header/profile_model.dart';
import 'package:frontend/src/core_components/single_avatar/single_avatar.dart';

@Component(
    selector: 'aside-menu',
    styleUrls: const <String>['aside_menu.css'],
    templateUrl: 'aside_menu.html',
    directives: const <Object>[
      NgFor,
      NgIf
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class AsideMenuComponent {
  final _pinCtrl = new StreamController<bool>(sync: true);

  @Output() Stream<bool> get onPin => _pinCtrl.stream;


  bool isPined = false;


  void onPinHandle() {
    isPined = !isPined;
    _pinCtrl.add(isPined);
  }
}
