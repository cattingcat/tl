import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:list/src/core_components/common/subscriptions.dart';
import 'package:list/src/task_list/card_components/dnd_events.dart';
import 'package:list/src/task_list/card_components/task_card_observer.dart';
import 'package:list/src/task_list/card_components/title_change_card_event.dart';
import 'package:list/src/task_list/card_components/toggle_card_event.dart';
import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/highlight_options.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/tree_view/events.dart';
import 'package:list/src/task_list/models/tree_view/tree_view.dart';
import 'package:list/src/task_list/sublist_component/sublist_component.dart';
import 'package:list/src/task_list/task_list_component/events/toggle_task_list_card_event.dart';
import 'package:list/src/task_list/task_list_component/utils/tree_iterable.dart';
import 'package:list/src/task_list/task_list_component/utils/view_model_mapper.dart';
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
class TaskListComponent implements AfterViewInit, OnChanges, OnDestroy, TaskCardObserver {
  final _subscr = new Subscriptions();
  final _toggleCtrl =     new StreamController<ToggleTaskListCardEvent>(sync: true);
  final _dragOverCtrl =   new StreamController<DndEvent>(sync: true);
  final _dragEnterCtrl =  new StreamController<DndEvent>(sync: true);
  final _dragLeaveCtrl =  new StreamController<DndEvent>(sync: true);
  final _dropCtrl =       new StreamController<DndEvent>(sync: true);
  final ViewModelMapper _viewModelMapper = new ViewModelMapper();
  final int _spaceSize = 200; // Space before/after viewport

  final Element _hostElement;
  final ChangeDetectorRef _cdr;

  _ViewportElement _viewportElement;
  _ScrollWrapperElement _scrollWrapper;

  ViewportModelsStatsDecorator _viewportModels;

  @Input() TreeView dataSource;
  @Input() HighlightOptions highlight;
  @Input() CardType cardType = CardType.Default;

  @Output() Stream<ToggleTaskListCardEvent> get cardToggle => _toggleCtrl.stream;
  @Output() Stream<DndEvent> get dragOver => _dragOverCtrl.stream;
  @Output() Stream<DndEvent> get dragEnter => _dragEnterCtrl.stream;
  @Output() Stream<DndEvent> get dragLeave => _dragLeaveCtrl.stream;
  @Output() Stream<DndEvent> get drop => _dropCtrl.stream;

  @ViewChild('viewport') Element viewportEl;
  @ViewChild('wrapper') Element wrapperEl;

  TaskListComponent(this._hostElement, this._cdr);


  TaskCardObserver get observer => this;

  SublistViewModel sublist;


  // <editor-fold desc="TaskCardObserver">

  @override
  void toggle(ToggleCardEvent event) {
    NgZone.assertNotInAngularZone();

    final model = event.model;
    assert(model.children.isNotEmpty, 'Expander shouldnt be shown for nodes without children');
    assert(_viewportModels.models.contains(model), 'Model should bew from viewport, cause of ScrollWrapper height calcaletion');

    final listEvent = new ToggleTaskListCardEvent(model, event.isExpanded);
    _toggleCtrl.add(listEvent);

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

    sublist = _viewModelMapper.map2(_viewportModels.models);

    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  @override
  void titleChange(TitleChangeCardEvent event) {
    print('title changed: ${event.model}');
  }


  @override
  void onDragOver(DndEvent event) {
    _dragOverCtrl.add(event);
  }

  @override
  void onDragEnter(DndEvent event) {
    _dragEnterCtrl.add(event);
  }

  @override
  void onDragLeave(DndEvent event) {
    _dragLeaveCtrl.add(event);
  }

  @override
  void onDrop(DndEvent event) {
    _dropCtrl.add(event);
  }

  // </editor-fold>


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('dataSource')) {
      _viewportElement = new _ViewportElement(viewportEl);
      _scrollWrapper = new _ScrollWrapperElement(wrapperEl);

      final treeView = changes['dataSource'].currentValue as TreeView;
      final card = (changes.containsKey('cardType') ? changes['cardType'].currentValue : cardType) as CardType;

      Zone.ROOT.run(() {
        _subscr
          ..cancelClear()
          ..listen(treeView.onAdd, _onAdd)
          ..listen(treeView.onRemove, _onRemove)
          ..listen(treeView.onUpdate, _onUpdate);
      });

      _viewportModels = new ViewportModelsStatsDecorator(new ViewportModels(treeView.tree), card);
      _scrollWrapper.setup(treeView, card);
      _hostElement.scrollTop = 0;
    }

    if(changes.containsKey('cardType') && !changes.containsKey('dataSource')) {
      final cardType = changes['cardType'].currentValue as CardType;
      _scrollWrapper.setup(dataSource, cardType);
      _viewportModels.cardType = cardType;
      _resetList();
    }

    if(changes.containsKey('highlight') && !changes.containsKey('dataSource')) {
      final highlight = changes['highlight'].currentValue as HighlightOptions;
      _viewModelMapper.highlightOptions = highlight;
    }
  }

  @override
  void ngAfterViewInit() {
    // It is out of NgZone, see assert in callback
    _hostElement.addEventListener('scroll', _handleScrollEvent);

    _resetList();
  }

  @override
  void ngOnDestroy() {
    _hostElement.removeEventListener('scroll', _handleScrollEvent);
    _subscr.cancelClear();
  }


  int _viewportStart = 0;
  void _handleScrollEvent(Event e) {
    NgZone.assertNotInAngularZone();

    final scrollTop = _hostElement.scrollTop;

    final targetViewportH = _estimatedViewportHeight;
    final targetViewportStart = (scrollTop - _spaceSize).clamp(0, _scrollWrapper.height);
    //final targetWiewportEnd = targetViewportStart + targetViewportH;

    final scrollDiff = targetViewportStart - _viewportStart;
    final diffAbs = scrollDiff.abs(); // from 0 to 2 * _spaceSize


    if(diffAbs.abs() >= _spaceSize
        || scrollTop == 0
        || scrollTop == _scrollWrapper.height - _hostElement.clientHeight) {

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

      sublist = _viewModelMapper.map2(_viewportModels.models);

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
  void _resetList() {
    _viewportStart = _hostElement.scrollTop = 0;
    _viewportModels.reset();

    int height = _estimatedViewportHeight;
    _viewportModels.takeFrontWhile((model) {
      height -= cardType.getHeight(model.type);
      return height > 0;
    });

    sublist = _viewModelMapper.map2(_viewportModels.models);

    _detectChanges();
  }

  void _detectChanges() {
    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  int get _estimatedViewportHeight => _hostElement.clientHeight + 2 * _spaceSize;
}

class _ViewportElement {
  final Element _viewportElement;
  int _offset = 0;

  _ViewportElement(this._viewportElement);


  int get offset => _offset;

  set offset(int value) {
    _offset = value;
    _viewportElement.style.transform = 'translate(0px, ${value}px)';
  }
}

class _ScrollWrapperElement {
  final Element _scrollWrapper;
  int _h = 0;

  _ScrollWrapperElement(this._scrollWrapper);


  int get height => _h;
  set height(int value) {
    _h = value;
    _scrollWrapper.style.height = '${_h}px';
  }

  void setup(TreeView dataSource, CardType cardType) {
    final flatTree = new TreeIterable.forward(dataSource.tree);
    final h = flatTree.map((i) => cardType.getHeight(i.type)).reduce((a, b) => a + b);
    _h = h;
    _scrollWrapper.style.height = '${_h}px';
  }
}