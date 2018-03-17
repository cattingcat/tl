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
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/tree_view/events.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list/sublist_component/sublist_component.dart';
import 'package:frontend/src/task_list/task_list_component/events/list_mouse_card_event.dart';
import 'package:frontend/src/task_list/task_list_component/events/toggle_task_list_card_event.dart';
import 'package:frontend/src/task_list/task_list_component/utils/scroll_helper.dart';
import 'package:frontend/src/task_list/task_list_component/utils/scroll_wrapper_element.dart';
import 'package:frontend/src/task_list/task_list_component/utils/task_card_observer_impl.dart';
import 'package:frontend/src/task_list/task_list_component/utils/tree_iterable.dart';
import 'package:frontend/src/task_list/task_list_component/utils/view_model_mapper.dart';
import 'package:frontend/src/task_list/task_list_component/utils/viewport_element.dart';
import 'package:frontend/src/task_list/task_list_component/utils/viewport_models.dart';
import 'package:frontend/src/task_list/view_models/sublist_view_model.dart';

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
  static const int _spaceSize = 200; // Space before/after viewport
  final _subscr = new Subscriptions(); // Subscriptions for all list lifecycle
  final _tmpSubscr = new Subscriptions(); // Data-source subscriptions

  final ViewModelMapper _viewModelMapper = new ViewModelMapper();
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
    Zone.ROOT.run(() {
      _subscr.listen<ToggleTaskListCardEvent>(_cardObserver.cardToggle, _onToggle);
      _hostEl.addEventListener('scroll', _handleScrollEvent);
    });
  }


  TaskCardObserver get observer => _cardObserver;

  SublistViewModel sublistViewModel;


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('dataSource')) {
      _viewportElement = new ViewportElement(viewportEl);
      _scrollWrapper = new ScrollWrapperElement(wrapperEl);

      final treeView = changes['dataSource'].currentValue as TreeView;
      final card = (changes.containsKey('cardType') ? changes['cardType'].currentValue : cardType) as CardType;

      Zone.ROOT.run(() {
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
    final scrollDiff = targetViewportStart - _scrollHelper.viewportStart;
    final diffAbs = scrollDiff.abs(); // from 0 to 2 * _spaceSize

    if(diffAbs.abs() >= _spaceSize
        || scrollTop == 0
        || scrollTop == _scrollWrapper.height - _hostEl.clientHeight) {

      _scrollHelper.scrollTo(targetViewportStart, _estimatedViewportHeight);
      _viewportElement.offset = _scrollHelper.viewportStart;
      sublistViewModel = _viewModelMapper.map2(_scrollHelper.models);

      _detectChanges();
    }
  }

  void _onUpdate(UpdateTreeEvent event) {
    NgZone.assertNotInAngularZone();

    _scrollWrapper.setup(dataSource, cardType);
    final vpModels = new ViewportModels(dataSource.tree);
    _scrollHelper = new ScrollHelper(vpModels, cardType, _scrollWrapper.height);

    _scrollHelper.resetTo(_estimatedViewportHeight, _hostEl.scrollTop - _spaceSize);
    _viewportElement.offset = _scrollHelper.viewportStart;

    sublistViewModel = _viewModelMapper.map2(_scrollHelper.models);

    _detectChanges();
  }

  void _onToggle(ToggleTaskListCardEvent event) {
    NgZone.assertNotInAngularZone();

    final model = event.model;
    assert(model.children.isNotEmpty, 'Expander shouldnt be shown for nodes without children');
    assert(_scrollHelper.models.contains(model), 'Model should bew from viewport, cause of ScrollWrapper height calcaletion');

    model.isExpanded = event.isExpanded;

    final iterable = new TreeIterable.node(model);
    final changedModels = iterable.skip(1); // skip first item because it will not be changed (is is [model])

    if(model.isExpanded) {
      _scrollHelper.addAfterViewport(changedModels);
    } else {
      _scrollHelper.removeAfterViewport(changedModels);
    }

    /// We don't need to update viewportOffset because update after viewport start
    _scrollHelper.refresh(_estimatedViewportHeight);
    _scrollWrapper.height = _scrollHelper.scrollHeight;
    sublistViewModel = _viewModelMapper.map2(_scrollHelper.models);

   _detectChanges();
  }


  /// Reset viewport and scroll position to initial state and re-render elements
  void _resetList() {
    _hostEl.scrollTop = 0;
    _scrollHelper.reset(_estimatedViewportHeight);

    sublistViewModel = _viewModelMapper.map2(_scrollHelper.models);
  }

  void _detectChanges() {
//    _changeDetectTimer?.cancel();
//    _changeDetectTimer = new Timer(const Duration(milliseconds: 20), () {
//      _cdr.markForCheck();
//      _cdr.detectChanges();
//    });

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
}