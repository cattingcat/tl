import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:list/src/task_list/card_components/default/task/default_task_card.dart';
import 'package:list/src/task_list/card_components/narrow/task/narrow_task_card.dart';
import 'package:list/src/task_list/card_components/task_card_observer.dart';
import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/view_models/sublist_view_model.dart';


@Component(
    selector: 'sublist',
    styleUrls: const <String>['sublist_component.css'],
    templateUrl: 'sublist_component.html',
    directives: const <Object>[
      CORE_DIRECTIVES,
      DefaultTaskCard,
      NarrowTaskCard,
      SublistComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class SublistComponent {
  @Input() SublistViewModel model;
  @Input() CardType cardType;
  @Input() TaskCardObserver observer;


  bool get isDefaultCard => cardType == CardType.Default;

  bool get isNarrowCard => cardType == CardType.Narrow;
}