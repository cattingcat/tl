import 'package:angular/angular.dart';
import 'package:frontend/src/app_header/item_model.dart';

@Component(
  selector: 'app-header',
  styleUrls: const <String>['app_header.css'],
  templateUrl: 'app_header.html',
  directives: const <Object>[
    NgFor,
    NgIf
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class AppHeaderComponent {
  final Iterable<ItemModel> items = [
    new ItemModel('Item 1', '', CounterLevel.None),
    new ItemModel('Item 2', '2', CounterLevel.None),
    new ItemModel('Item 3', '3', CounterLevel.Yellow),
    new ItemModel('Item 4', '4', CounterLevel.Red)
  ];

  ItemModel get activeItem => items.last;


  bool isActive(ItemModel item) => activeItem == item;

  bool showIndicator(ItemModel item) =>
    item.level != CounterLevel.None && item.title != null && item.title.isNotEmpty;
}
