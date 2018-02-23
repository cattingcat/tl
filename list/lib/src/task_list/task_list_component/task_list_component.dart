import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:list/src/core_components/common/subscriptions.dart';
import 'package:list/src/task_list/card_components/default/task/default_task_card.dart';
import 'package:list/src/task_list/card_components/narrow/task/narrow_task_card.dart';
import 'package:list/src/task_list/card_components/title_change_card_event.dart';
import 'package:list/src/task_list/card_components/toggle_card_event.dart';
import 'package:list/src/task_list/models/list_view/events.dart';
import 'package:list/src/task_list/models/list_view/list_view.dart';
import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/task_list_component/events/toggle_task_list_card_event.dart';
import 'package:list/src/task_list/task_list_component/utils/viewport_models.dart';
import 'package:list/src/task_list/view_models/data_source/view_model_mapper.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

@Component(
  selector: 'task-list',
  styleUrls: const <String>['task_list_component.css'],
  templateUrl: 'task_list_component.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    DefaultTaskCard,
    NarrowTaskCard
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListComponent implements AfterViewInit, OnChanges {
  final _subscr = new Subscriptions();
  final _toggleCtrl = new StreamController<ToggleTaskListCardEvent>(sync: true);
  final ViewModelMapper _viewModelMapper = new ViewModelMapper();
  final int _spaceSize = 200; // Space before/after viewport

  final NgZone _ngZone;
  final Element _hostElement;
  final ChangeDetectorRef _cdr;

  _ViewportElement _viewportElement;
  _ScrollWrapperElement _scrollWrapper;

  ViewportModels _viewportModels;

  @Input() ListView dataSource;
  @Input() CardType cardType = CardType.Default;

  @Output() Stream<ToggleTaskListCardEvent> get cardToggle => _toggleCtrl.stream;

  @ViewChild('viewport') Element viewportEl;
  @ViewChild('wrapper') Element wrapperEl;

  TaskListComponent(this._ngZone, this._hostElement, this._cdr);


  Iterable<TaskListViewModel> models;

  bool get isDefaultCard => cardType == CardType.Default;

  bool get isNarrowCard => cardType == CardType.Narrow;


  void onToggle(ToggleCardEvent event) {
    final model = event.model;
    final cardIndex = _viewportModels.getIndexOfModel(model);
    final listEvent = new ToggleTaskListCardEvent(model, cardIndex, event.isExpanded);

    _toggleCtrl.add(listEvent);
  }

  void onTitleChange(TitleChangeCardEvent event) {
    print('title changed: ${event.model}');
  }


  int trackFunction(int index, TaskListViewModel model) {
    return model.hashCode;
  }


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('dataSource')) {
      _viewportElement = new _ViewportElement(viewportEl);
      _scrollWrapper = new _ScrollWrapperElement(wrapperEl);

      final ds = changes['dataSource'].currentValue as ListView;
      final card = (changes.containsKey('cardType') ? changes['cardType'].currentValue : cardType) as CardType;

      _ngZone.runOutsideAngular(() {
        _subscr
          ..cancelClear()
          ..listen(ds.onAdd, _onAdd)
          ..listen(ds.onRemove, _onRemove)
          ..listen(ds.onUpdate, _onUpdate);
      });

      _viewportModels = new ViewportModels(ds);

      _scrollWrapper.setup(ds, card);

      // update scroll position
      _hostElement.scrollTop = 0;
    }

    if(changes.containsKey('cardType') && !changes.containsKey('dataSource')) {
      final cardType = changes['cardType'].currentValue as CardType;
      _scrollWrapper.setup(dataSource, cardType);
    }
  }

  @override
  void ngAfterViewInit() {
    // It is out of NgZone, see assert in callback
    _hostElement.addEventListener('scroll', _handleScrollEvent);

    print('host h: ${_hostElement.clientHeight}');

    int height = _hostElement.clientHeight + _spaceSize * 2;
    _viewportModels.takeFrontWhile((model) {
      height -= cardType.getHeight(model.type);
      return height > 0;
    });

    final viewModels = _viewModelMapper.map(_viewportModels.models);
    models = viewModels;

    _cdr.markForCheck();
    _cdr.detectChanges();
  }


  int _viewportStart = 0;
  void _handleScrollEvent(Event e) {
    NgZone.assertNotInAngularZone();

    final scrollTop = _hostElement.scrollTop;

    final targetViewportH = _hostElement.clientHeight + 2 * _spaceSize;
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

      final viewModels = _viewModelMapper.map(_viewportModels.models);
      models = viewModels;

      _cdr.markForCheck();
      _cdr.detectChanges();
    }
  }


  void _onAdd(ListViewAddRemoveEvent event) {
    NgZone.assertNotInAngularZone();

    _scrollWrapper.height +=
        (event.stats.taskCount * cardType.taskCardHeight) +
        (event.stats.groupCount * cardType.groupCardHeight) +
        (event.stats.folderCount * cardType.folderCardHeight);

    // TODO: actualize scroll

    _cdr.markForCheck();
    _cdr.detectChanges();

    print(event);
  }

  void _onRemove(ListViewAddRemoveEvent event) {
    NgZone.assertNotInAngularZone();

    _scrollWrapper.height -=
        (event.stats.taskCount * cardType.taskCardHeight) +
        (event.stats.groupCount * cardType.groupCardHeight) +
        (event.stats.folderCount * cardType.folderCardHeight);

    // TODO: actualize scroll

    _cdr.markForCheck();
    _cdr.detectChanges();

    print(event);
  }

  void _onUpdate(ListViewEvent event) {
    NgZone.assertNotInAngularZone();

    print(event);
  }
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

  void setup(ListView dataSource, CardType cardType) {
    final h = dataSource.models.map((i) => cardType.getHeight(i.type)).reduce((a, b) => a + b);
    _h = h;
    _scrollWrapper.style.height = '${_h}px';
  }
}