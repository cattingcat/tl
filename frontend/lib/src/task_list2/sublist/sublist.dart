import 'package:angular/angular.dart';
import 'package:frontend/src/task_list/card_components/default/group/default_group_card.dart';
import 'package:frontend/src/task_list/card_components/default/task/default_task_card.dart';
import 'package:frontend/src/task_list/card_components/narrow/task/narrow_task_card.dart';
import 'package:frontend/src/task_list/card_components/task_card_observer.dart';
import 'package:frontend/src/task_list/card_type.dart';
import 'package:frontend/src/task_list/highlight_options.dart';
import 'package:frontend/src/task_list/models/model_type.dart';
import 'package:frontend/src/task_list/models/root_model.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/task_list_component/utils/view_model_mapper.dart';
import 'package:frontend/src/task_list/view_models/task_list_view_model.dart';
import 'package:frontend/src/task_list2/sublist/render_interval.dart';
import 'package:frontend/src/task_list2/sublist/sublist_item.dart';

export 'package:frontend/src/task_list2/sublist/render_interval.dart';
export 'package:frontend/src/task_list2/sublist/sublist_item.dart';

@Component(
    selector: 'sublist',
    styleUrls: const <String>['sublist.css'],
    templateUrl: 'sublist.html',
    directives: const <Object>[
      NgIf,
      NgFor,

      SublistComponent,

      DefaultTaskCard,
      NarrowTaskCard,
      DefaultGroupCard,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class SublistComponent {
  final ViewModelMapper _mapper = new ViewModelMapper();
  final List<SublistItem> sublistItems = new List<SublistItem>();
  final Map<TaskListModel, SublistItem> _cache = new Map<TaskListModel, SublistItem>();

  SublistItem _item;
  TaskListViewModel _headerViewModel;


  @Input() TaskCardObserver observer;
  @Input() CardType cardType;
  @Input() HighlightOptions highlight;

  SublistItem get item => _item;
  @Input() set item(SublistItem value) {
    assert(value != null);
    assert(value.root != null);

    _prepareHeaderModel(value);
    _prepareSubListsModels(value);

    _item = value;
  }



  bool get isGroupCard => model.type == ModelType.Group;

  bool get isDefaultTaskCard => model.type == ModelType.Task && cardType == CardType.Default;

  bool get isNarrowTaskCard => model.type == ModelType.Task && cardType == CardType.Narrow;


  bool get highlightBefore => _hlThis && highlight.position == HighlightPosition.Before;

  bool get highlightAfter => _hlThis && highlight.position == HighlightPosition.After;

  bool get highlightCenter => _hlThis && highlight.position == HighlightPosition.Center;

  bool get highlightSublist => _hlThis && highlight.position == HighlightPosition.Sublist;



  TaskListModel get model => _item.root;

  TaskListViewModel get headerModel => _headerViewModel;

  bool get showHeader {
    final interval = _item.renderInterval;
    return (interval.from == null || interval.from.length == 1) && _item != null && _item.root is! RootModel;
  }

  bool get showSubList {
    final renderInterval = _item.renderInterval;

    return root.children.isNotEmpty && root.isExpanded &&
        (renderInterval.to == null ||
        !(renderInterval.to.length == 2 && renderInterval.to[1] == root));
  }

  int trackByFunc(int index, SublistItem item) {
    return item.root.hashCode;
  }

  TaskListModel get root => _item.root;

  String get title => root.toString();

  bool get _hlThis => highlight != null && highlight.model == model;

  void _prepareHeaderModel(SublistItem value) {
    if(value.root is! RootModel && (_headerViewModel == null || item.root != value.root)) {
      _headerViewModel = _mapper.mapModel(value.root);
    }
  }

  void _prepareSubListsModels(SublistItem value) {
    final interval = value.renderInterval;
    final children = value.root.children;

    TaskListModel start;
    List<TaskListModel> startFromInterval;
    TaskListModel end;
    List<TaskListModel> endToInterval;

    if(children.isNotEmpty) {
      if (interval.from != null) {
        start = interval.from[1];
        startFromInterval = _getChildrenPath(interval.from);
      } else {
        start = children.first;
        startFromInterval = null;
      }

      if (interval.to != null) {
        end = interval.to[1];
        endToInterval = _getChildrenPath(interval.to);
      } else {
        end = children.last;
        endToInterval = null;
      }
    }

    if(start == end) {
      sublistItems.clear();

      if(start != null) {
        final interval = new RenderInterval(startFromInterval, endToInterval);
        final item = new SublistItem(start, interval);
        sublistItems.add(item);
      } else {
        // No children
      }

    } else {
      sublistItems.forEach((i) => _cache[i.root] = i);
      sublistItems.clear();

      final startItem = new SublistItem(start, new RenderInterval.fromAnchor(startFromInterval));
      sublistItems.add(startItem);

      TaskListModel iter = start.next;
      while(iter != end) {
        final item = _getOpenSublistItemFor(iter);
        sublistItems.add(item);
        iter = iter.next;
      }

      final endItem = new SublistItem(end, new RenderInterval.toAnchor(endToInterval));
      sublistItems.add(endItem);

      _cache.clear();
    }
  }

  List<TaskListModel> _getChildrenPath(List<TaskListModel> value) {
    assert(value == null || value.length >= 2, 'Root + child item, or null');

    final len = value.length;
    final childInterval = len == 2 ? null : value.sublist(1, len);
    return childInterval;
  }

  SublistItem _getOpenSublistItemFor(TaskListModel model) {
    final m = _cache[model];
    if(m != null && m.renderInterval.from == null && m.renderInterval.to == null) return m;
    return new SublistItem.open(model);
  }
}




