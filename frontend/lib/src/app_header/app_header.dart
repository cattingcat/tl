import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/app_header/header_events.dart';
import 'package:frontend/src/app_header/item_model.dart';
import 'package:frontend/src/app_header/profile_model.dart';
import 'package:frontend/src/core_components/single_avatar/single_avatar.dart';

export 'package:frontend/src/app_header/header_events.dart';
export 'package:frontend/src/app_header/item_model.dart';
export 'package:frontend/src/app_header/profile_model.dart';


@Component(
  selector: 'app-header',
  styleUrls: const <String>['app_header.css'],
  templateUrl: 'app_header.html',
  directives: const <Object>[
    NgFor,
    NgIf,
    SingleAvatarComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class AppHeaderComponent {
  final _radioItemClickCtrl = new StreamController<RadioItemClickEvent>(sync: true);
  final _profileClickCtrl = new StreamController<HeaderItemClickEvent>(sync: true);
  final _hamClickCtrl = new StreamController<Null>(sync: true);

  @Input() ProfileModel profile;
  @Input() Iterable<ItemModel> items;
  @Input() ItemModel activeItem;

  @Output() Stream<RadioItemClickEvent> get radioClick => _radioItemClickCtrl.stream;
  @Output() Stream<HeaderItemClickEvent> get profileClick => _profileClickCtrl.stream;
  @Output() Stream<Null> get hamburgerClick => _hamClickCtrl.stream;


  bool isActive(ItemModel item) => activeItem == item;


  void onRadioClick(html.MouseEvent event, ItemModel model) {
    event.preventDefault();

    final e = new RadioItemClickEvent(event, model);
    _radioItemClickCtrl.add(e);
  }

  void onProfileClick(html.MouseEvent event) {
    final e = new HeaderItemClickEvent(event);
    _profileClickCtrl.add(e);
  }

  void onHamClick() {
    _hamClickCtrl.add(null);
  }
}
