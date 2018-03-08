import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:list/src/core_components/common/subscriptions.dart';
import 'package:list/src/task_list/card_components/dnd_events.dart';
import 'package:list/src/task_list/card_components/task_card_observer.dart';
import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/highlight_options.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/tree_view/events.dart';
import 'package:list/src/task_list/models/tree_view/tree_view.dart';
import 'package:list/src/task_list/sublist_component/sublist_component.dart';
import 'package:list/src/task_list/task_list_component/events/toggle_task_list_card_event.dart';
import 'package:list/src/task_list/task_list_component/utils/scroll_wrapper_element.dart';
import 'package:list/src/task_list/task_list_component/utils/task_card_observer_impl.dart';
import 'package:list/src/task_list/task_list_component/utils/tree_iterable.dart';
import 'package:list/src/task_list/task_list_component/utils/view_model_mapper.dart';
import 'package:list/src/task_list/task_list_component/utils/viewport_element.dart';
import 'package:list/src/task_list/task_list_component/utils/viewport_models.dart';
import 'package:list/src/task_list/task_list_component/utils/viewport_models_stats_decorator.dart';
import 'package:list/src/task_list/view_models/sublist_view_model.dart';

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

  ViewportElement _viewportElement;
  ScrollWrapperElement _scrollWrapper;

  ViewportModelsStatsDecorator _viewportModels;

  @Input() TreeView dataSource;
  @Input() HighlightOptions highlight;
  @Input() CardType cardType = CardType.Default;

  @Output() Stream<ToggleTaskListCardEvent> get cardToggle => _cardObserver.cardToggle;
  @Output() Stream<DndEvent> get dragOver => _cardObserver.dragOver;
  @Output() Stream<DndEvent> get dragEnter => _cardObserver.dragEnter;
  @Output() Stream<DndEvent> get dragLeave => _cardObserver.dragLeave;
  @Output() Stream<DndEvent> get drop => _cardObserver.drop;

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
          ..listen(treeView.onAdd, _onAdd)
          ..listen(treeView.onRemove, _onRemove)
          ..listen(treeView.onUpdate, _onUpdate);
      });

      _viewportModels = new ViewportModelsStatsDecorator(new ViewportModels(treeView.tree), card);
      _scrollWrapper.setup(treeView, card);
      _hostEl.scrollTop = 0;
      _resetViewModel();
    }

    if(changes.containsKey('cardType') && !changes.containsKey('dataSource')) {
      final cardType = changes['cardType'].currentValue as CardType;
      _scrollWrapper.setup(dataSource, cardType);
      _viewportModels.cardType = cardType;
      _resetViewModel();
    }
  }

  @override
  void ngOnDestroy() {
    _hostEl.removeEventListener('scroll', _handleScrollEvent);
    _tmpSubscr.cancelClear();
    _subscr.cancelClear();
  }


  int _viewportStart = 0;
  void _handleScrollEvent(Event e) {
    NgZone.assertNotInAngularZone();

    final scrollTop = _hostEl.scrollTop;

    final targetViewportH = _estimatedViewportHeight;
    final targetViewportStart = (scrollTop - _spaceSize).clamp(0, _scrollWrapper.height);
    //final targetWiewportEnd = targetViewportStart + targetViewportH;

    final scrollDiff = targetViewportStart - _viewportStart;
    final diffAbs = scrollDiff.abs(); // from 0 to 2 * _spaceSize


    if(diffAbs.abs() >= _spaceSize
        || scrollTop == 0
        || scrollTop == _scrollWrapper.height - _hostEl.clientHeight) {

      print('Need re-render with diff: $scrollDiff');

      if(scrollDiff > 0) {

        int takeAcc = 0;
        _viewportModels.takeFrontWhile((model) {
          final modelH = cardType.getHeight(model.type);
          if(takeAcc < diffAbs) {
            takeAcc += modelH;
            return true;
          }

          return false;
        });

        final currentViewportH = _viewportModels.models
            .map((i) => cardType.getHeight(i.type))
            .reduce((a, b) => a + b);

        if(currentViewportH > targetViewportH) {
          int toRemove = currentViewportH - targetViewportH;
          int actualRemoved = 0;
          _viewportModels.removeBackWhile((model) {
            final modelH = cardType.getHeight(model.type);
            if(toRemove > 0) {
              toRemove -= modelH;
              actualRemoved += modelH;
              return true;
            }

            return false;
          });

          _viewportStart += actualRemoved;

        } else {
          print('!!!!!!1111 arr, add back when scroll to bottom');
        }

      } else {
        int takeAcc = 0;
        _viewportModels.takeBackWhile((model) {
          final modelH = cardType.getHeight(model.type);
          if(takeAcc < diffAbs) {
            takeAcc += modelH;
            return true;
          }

          return false;
        });

        int removeAcc = 0;
        _viewportModels.removeFrontWhile((model) {
          if(removeAcc < diffAbs) {
            removeAcc += cardType.getHeight(model.type);
            return true;
          }

          return false;
        });

        _viewportStart -= takeAcc;
      }

      _viewportElement.offset = _viewportStart;

      sublistViewModel = _viewModelMapper.map2(_viewportModels.models);

      _cdr.markForCheck();
      _cdr.detectChanges();
    }
  }


  void _onAdd(AddTreeEvent event) {
    NgZone.assertNotInAngularZone();
  }

  void _onRemove(RemoveTreeEvent event) {
    NgZone.assertNotInAngularZone();
  }

  void _onUpdate(UpdateTreeEvent event) {
    NgZone.assertNotInAngularZone();
  }

  void _onToggle(ToggleTaskListCardEvent event) {
    NgZone.assertNotInAngularZone();

    final model = event.model;
    assert(model.children.isNotEmpty, 'Expander shouldnt be shown for nodes without children');
    assert(_viewportModels.models.contains(model), 'Model should bew from viewport, cause of ScrollWrapper height calcaletion');

    model.isExpanded = event.isExpanded;

    final iterable = new TreeIterable.node(model);
    final height = iterable
        .skip(1) // skip first item because it will not be changed (is is [model])
        .map((m) => cardType.getHeight(m.type))
        .reduce((a, b) => a + b);
    if(model.isExpanded) {
      _scrollWrapper.height += height;
    } else {
      _scrollWrapper.height -= height;
    }

    _refreshModelsAfter(model);

    sublistViewModel = _viewModelMapper.map2(_viewportModels.models);

   _detectChanges();
  }


  void _refreshModelsAfter(TaskListModelBase model) {
    // remove models after [models]
    _viewportModels.removeFrontWhile((m) =>  m != model);

    // then fill blank space
    int toAdd = _estimatedViewportHeight - _viewportModels.height;
    _viewportModels.takeFrontWhile((m) {
      if(toAdd > 0) {
        toAdd -= cardType.getHeight(m.type);
        return true;
      }

      return false;
    });
  }

  /// Reset viewport and scroll position to initial state and re-render elements
  void _resetViewModel() {
    _viewportStart = _hostEl.scrollTop = 0;
    _viewportModels.reset();

    int height = _estimatedViewportHeight;
    _viewportModels.takeFrontWhile((model) {
      height -= cardType.getHeight(model.type);
      return height > 0;
    });

    sublistViewModel = _viewModelMapper.map2(_viewportModels.models);
  }

  void _detectChanges() {
    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  int get _estimatedViewportHeight => _hostEl.clientHeight + 2 * _spaceSize;
}