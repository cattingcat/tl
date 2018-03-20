import 'dart:async';

import 'package:angular/angular.dart';
import 'package:frontend/src/app_header/app_header.dart';
import 'package:frontend/src/aside_menu/aside_menu.dart';


@Component(
  selector: 'app-menus',
  styleUrls: const <String>['app_menus.css'],
  templateUrl: 'app_menus.html',
  directives: const <Object>[
    AppHeaderComponent,
    AsideMenuComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class AppMenusComponent {
  final _headerItemClickCtrl = new StreamController<ItemModel>(sync: true);

  bool menuHidden = true;
  bool menuPin = false;

  @Input() ProfileModel profile;
  @Input() Iterable<ItemModel> headerItems;
  @Input() ItemModel activeItem;

  @Output() Stream<ItemModel> get headerItemClick => _headerItemClickCtrl.stream;


  void onMenuToggle() => menuHidden = !menuHidden;

  void onMenuPin() => menuPin = !menuPin;

  void onRadioClick(RadioItemClickEvent event) => _headerItemClickCtrl.add(event.model);
}

