import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/app_header/header_events.dart';
import 'package:frontend/src/app_header/item_model.dart';
import 'package:frontend/src/app_header/profile_model.dart';
import 'package:frontend/src/core_components/single_avatar/single_avatar.dart';

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

  final Iterable<ItemModel> items = [
    new ItemModel('Item 1', '', CounterLevel.None),
    new ItemModel('Item 2', '2', CounterLevel.None),
    new ItemModel('Item 3', '3', CounterLevel.Yellow),
    new ItemModel('Item 4', '4', CounterLevel.Red)
  ];

  @Input() ProfileModel profile;

  @Output() Stream<RadioItemClickEvent> get radioClick => _radioItemClickCtrl.stream;
  @Output() Stream<HeaderItemClickEvent> get profileClick => _profileClickCtrl.stream;
  @Output() Stream<Null> get hamburgerClick => _hamClickCtrl.stream;


  ItemModel get activeItem => items.last;
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
