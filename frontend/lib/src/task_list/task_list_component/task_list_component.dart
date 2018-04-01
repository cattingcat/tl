import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/common/subscriptions.dart';
import 'package:frontend/src/task_list/card_components/mouse_card_event.dart';
import 'package:frontend/src/task_list/card_components/dnd_events.dart';
import 'package:frontend/src/task_list/card_components/task_card_observer.dart';
import 'package:frontend/src/task_list/card_type.dart';
import 'package:frontend/src/task_list/core/card_size_mapper.dart';
import 'package:frontend/src/task_list/highlight_options.dart';
import 'package:frontend/src/task_list/models/task_list_model.dart';
import 'package:frontend/src/task_list/models/tree_view/events.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list/task_list_component/events/list_mouse_card_event.dart';
import 'package:frontend/src/task_list/task_list_component/events/toggle_task_list_card_event.dart';
import 'package:frontend/src/task_list/task_list_component/utils/scroll_helper.dart';
import 'package:frontend/src/task_list/task_list_component/utils/scroll_wrapper_element.dart';
import 'package:frontend/src/task_list/task_list_component/utils/task_card_observer_impl.dart';
import 'package:frontend/src/task_list/task_list_component/utils/task_tree_iterables.dart';
import 'package:frontend/src/task_list/task_list_component/utils/viewport_element.dart';
import 'package:frontend/src/task_list/task_list_component/utils/viewport_models.dart';
import 'package:frontend/src/task_list/sublist/sublist.dart';

@Component(
  selector: 'task-list',
  styleUrls: const <String>['task_list_component.css'],
  templateUrl: 'task_list_component.html',
  directives: const <Object>[
    NgIf,

    SublistComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListComponent implements OnChanges, OnDestroy {
  static const int _spaceSize = 225; // Space before/after viewport
  final _subscr = new Subscriptions(); // Subscriptions for all list lifecycle
  final _tmpSubscr = new Subscriptions(); // Data-source subscriptions

  final TaskCardObserverImpl _cardObserver = new TaskCardObserverImpl();

  final Element _hostEl;
  final ChangeDetectorRef _cdr;

  Timer _changeDetectTimer;
  ViewportElement _viewportElement;
  ScrollWrapperElement _scrollWrapper;
  ScrollHelper _scrollHelper;

  @Input() TreeView dataSource;
  @Input() HighlightOptions highlight;
  @Input() CardSizeMapper<TaskListModel> cardType = CardType.Default;

  @Output() Stream<ToggleTaskListCardEvent> get cardToggle => _cardObserver.cardToggle;
  @Output() Stream<MouseCardEvent> get clickCard => _cardObserver.clickCard;
  @Output() Stream<DndEvent> get dragOver => _cardObserver.dragOver;
  @Output() Stream<DndEvent> get dragEnter => _cardObserver.dragEnter;
  @Output() Stream<DndEvent> get dragLeave => _cardObserver.dragLeave;
  @Output() Stream<DndEvent> get drop => _cardObserver.drop;
  @Output() Stream<ListMouseCardEvent> get cardMouseEnter => _cardObserver.mouseEnter.map(_mapListMouseEvent);
  @Output() Stream<ListMouseCardEvent> get cardMouseLeave => _cardObserver.mouseLeave.map(_mapListMouseEvent);
  @Output() Stream<ListMouseCardEvent> get cardMouseMove => _cardObserver.mouseMove.map(_mapListMouseEvent);

  @ViewChild('viewport') Element viewportEl;
  @ViewChild('wrapper') Element wrapperEl;

  TaskListComponent(this._hostEl, this._cdr) {
    Zone.root.run(() {
      _subscr.listen<ToggleTaskListCardEvent>(_cardObserver.cardToggle, _onToggle);
      _hostEl.addEventListener('scroll', _handleScrollEvent);
    });
  }


  TaskCardObserver get observer => _cardObserver;

  SublistItem subListModel;


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('dataSource')) {
      _viewportElement = new ViewportElement(viewportEl);
      _scrollWrapper = new ScrollWrapperElement(wrapperEl);

      final treeView = changes['dataSource'].currentValue as TreeView;
      final card = (changes.containsKey('cardType') ? changes['cardType'].currentValue : cardType) as CardType;

      Zone.root.run(() {
        _tmpSubscr
          ..cancelClear()
//          ..listen(treeView.onAdd, _onAdd)
//          ..listen(treeView.onRemove, _onRemove)
          ..listen(treeView.onUpdate, _onUpdate);
      });

      _scrollWrapper.setup(treeView, card);

      final vpModels = new ViewportModels(treeView.tree);
      _scrollHelper = new ScrollHelper(vpModels, card, _scrollWrapper.height);

      _resetList();
    }

    if(changes.containsKey('cardType') && !changes.containsKey('dataSource')) {
      final cardType = changes['cardType'].currentValue as CardType;
      _scrollWrapper.setup(dataSource, cardType);

      final vpModels = new ViewportModels(dataSource.tree);
      _scrollHelper = new ScrollHelper(vpModels, cardType, _scrollWrapper.height);

      _resetList();
    }
  }

  @override
  void ngOnDestroy() {
    _hostEl.removeEventListener('scroll', _handleScrollEvent);
    _tmpSubscr.cancelClear();
    _subscr.cancelClear();
  }


  void _handleScrollEvent(Event e) {
    NgZone.assertNotInAngularZone();

    final scrollTop = _hostEl.scrollTop;
    final targetViewportStart = (scrollTop - _spaceSize).clamp(0, _scrollWrapper.height);
    final scrollDiff = targetViewportStart - _viewportElement.offset;
    final diffAbs = scrollDiff.abs(); // from 0 to 2 * _spaceSize

    final duration = (diffAbs < _spaceSize * 2) ? 0 : 0;

    if(diffAbs < _spaceSize * 2) {
      if(diffAbs.abs() >= _spaceSize - 50
          || scrollTop == 0
          || scrollTop == _scrollWrapper.height - _hostEl.clientHeight) {

        _scrollHelper.scrollTo(targetViewportStart, _estimatedViewportHeight);

        _updateViewport();
      }
    } else {
      _changeDetectTimer?.cancel();
      _changeDetectTimer = new Timer(new Duration(milliseconds: duration), () {
        if (diffAbs.abs() >= _spaceSize - 50
            || scrollTop == 0
            || scrollTop == _scrollWrapper.height - _hostEl.clientHeight) {
          _scrollHelper.scrollTo(targetViewportStart, _estimatedViewportHeight);

          _updateViewport();
        }
      });
    }
  }

  void _onUpdate(UpdateTreeEvent event) {
    NgZone.assertNotInAngularZone();

    _scrollWrapper.setup(dataSource, cardType);
    final vpModels = new ViewportModels(dataSource.tree);
    _scrollHelper = new ScrollHelper(vpModels, cardType, _scrollWrapper.height);

    _scrollHelper.resetTo(_estimatedViewportHeight, _hostEl.scrollTop - _spaceSize);

    _updateViewport();
  }

  void _onToggle(ToggleTaskListCardEvent event) {
    NgZone.assertNotInAngularZone();

    final model = event.model;
    assert(model.children.isNotEmpty, 'Expander shouldnt be shown for nodes without children');
    assert(_scrollHelper.models.contains(model), 'Model should bew from viewport, cause of ScrollWrapper height calcaletion');

    model.isExpanded = event.isExpanded;

    final iterable = TaskTreeIterables.subTree(model);
    final changedModels = iterable.skip(1); // skip first item because it will not be changed (is is [model])

    if(model.isExpanded) {
      _scrollHelper.addAfterViewport(changedModels);
    } else {
      _scrollHelper.removeAfterViewport(changedModels);
    }

    /// We don't need to update viewportOffset because update after viewport start
    _scrollHelper.refresh(_estimatedViewportHeight);
    _scrollWrapper.height = _scrollHelper.scrollHeight;
    subListModel = _prepareSublistModel();

    _updateViewport();
  }


  /// Reset viewport and scroll position to initial state and re-render elements
  void _resetList() {
    _hostEl.scrollTop = 0;
    _scrollHelper.reset(_estimatedViewportHeight);

    subListModel = _prepareSublistModel();
  }

  void _updateViewport() {
    subListModel = _prepareSublistModel();
    _viewportElement.offset = _scrollHelper.viewportStart;

    _detectChanges();
  }

  void _detectChanges() {
    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  int get _estimatedViewportHeight => _hostEl.clientHeight + 2 * _spaceSize;


  ListMouseCardEvent _mapListMouseEvent(MouseCardEvent event) {
    final virtualVpOffserFromReal = (_hostEl.scrollTop - _scrollHelper.viewportStart);
    final originalOffset = event.nativeElement.offset; // Offset from viewport el
    final offset = new Point<int>(originalOffset.left, originalOffset.top - virtualVpOffserFromReal);
    return new ListMouseCardEvent.fromCardEvent(event, offset);
  }

  SublistItem _prepareSublistModel() {
    final fromModel = _scrollHelper.models.first;
    final toModel = _scrollHelper.models.last;
    final root = dataSource.tree.root;

    final reversedFromPath = new List<TaskListModel>();
    TaskListModel iter = fromModel;
    while(iter != null) {
      reversedFromPath.add(iter);
      iter = iter.parent;
    }
    reversedFromPath.add(root);

    final reversedToPath = new List<TaskListModel>();
    iter = toModel;
    while(iter != null) {
      reversedToPath.add(iter);
      iter = iter.parent;
    }
    reversedToPath.add(root);


    return new SublistItem(root,
        new RenderInterval(reversedFromPath.reversed.toList(), reversedToPath.reversed.toList()));
  }
}