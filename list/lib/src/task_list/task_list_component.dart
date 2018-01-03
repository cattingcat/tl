import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:list/src/task_list/core/card_type.dart';
import 'package:list/src/task_list/core/model_data_source.dart';
import 'package:list/src/task_list/core/task_list_model.dart';
import 'package:list/src/task_list/task_card/task_card_component.dart';

@Component(
  selector: 'task-list',
  styleUrls: const <String>['task_list_component.scss.css'],
  templateUrl: 'task_list_component.html',
  directives: const <Object>[
    CORE_DIRECTIVES,
    TaskCardComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TaskListComponent implements AfterViewInit, OnChanges {
  static const int _taskBatchSize = 40;
  static const int _cardSize = 35;
  static const int _taskRequestCount = 5;

  final ElementRef _hostElementRef;
  final ChangeDetectorRef _cdr;

  Debouncer _scrollDebouncer;
  _ViewportElement _viewportElement;
  _ScrollWrapperElement _scrollWrapper;
  _Viewport _viewportModels;

  @Input() ModelDataSource dataSource;
  @Input() CardType cardType;

  @ViewChild('viewport') ElementRef viewportElRef;
  @ViewChild('wrapper') ElementRef wrapper;

  TaskListComponent(this._hostElementRef, this._cdr) {
    _scrollDebouncer = new Debouncer(_handleScroll);
  }


  Element get host => _hostElementRef.nativeElement as Element;

  Iterable<TaskListModel> get models => _viewportModels.models;

  int trackFunction(int index, TaskListModel model) {
    return model.text.hashCode;
  }


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('dataSource')) {
      _init();
      final ds = changes['dataSource'].currentValue as ModelDataSource;
      final card = (changes.containsKey('cardType') ? changes['cardType'].currentValue : cardType) as CardType;

      _viewportModels.setup(ds);
      _viewportElement.setup(cardType, _taskBatchSize);
      _scrollWrapper.setup(ds, card);


      // update scroll position
      _scrollTop = _prevScroll = host.scrollTop = 0;
    }

    if(changes.containsKey('cardType') && !changes.containsKey('dataSource')) {
      final cardType = changes['cardType'].currentValue as CardType;
      _scrollWrapper.setup(dataSource, cardType);
    }
  }

  @override
  void ngAfterViewInit() {
    host.addEventListener('scroll', _handleScrollEvent);
  }


  int _scrollTop = 0;
  int _prevScroll = 0;
  void _handleScrollEvent(Event e) {
    _scrollTop = host.scrollTop;

    if((_scrollTop - _prevScroll).abs() > _viewportElement.height) {
      _scrollDebouncer.execImmediately();
    } else {
      _scrollDebouncer.exec();
    }

    _prevScroll = _scrollTop;
  }

  void _handleScroll() {
    final clientHeight = host.clientHeight;
    final max = _scrollWrapper.height - clientHeight;
    final scrollTop = host.scrollTop;
    if(scrollTop == 0) {
      _viewportElement.offset = 0;
      _viewportModels.setViewportStart(0);
    }

    print('$scrollTop of $max; $clientHeight');




    final clientCenter = _scrollTop + clientHeight / 2; // Offset from wrapper start to center

    final viewportCenter = _viewportElement.offset + _viewportElement.height / 2;

    final diff = clientCenter - viewportCenter;
    final cardDiff = diff / _cardSize;

    final currentModelsIndex = _viewportModels.start;
    final newOffset = _viewportElement.offset + diff;
    final newModelIndex = currentModelsIndex + cardDiff.floor();

    bool detectChanges = false;
    if(cardDiff > _taskRequestCount) {
      final index = newModelIndex + _taskBatchSize > dataSource.length ? dataSource.length - _taskBatchSize : newModelIndex;
      if(index != currentModelsIndex) {
        _viewportModels.setViewportStart(index);
        detectChanges = true;

        final offset = newOffset > _scrollWrapper.height ? _scrollWrapper.height - _viewportElement.height : newOffset;
        _viewportElement.offset = offset.toInt();
      }

    } else if(cardDiff < -_taskRequestCount) {
      final index = newModelIndex > 0 ? newModelIndex : 0;
      if(index != currentModelsIndex) {
        _viewportModels.setViewportStart(index);
        detectChanges = true;


        final offset = newOffset > 0 ? newOffset : 0;
        _viewportElement.offset = offset.toInt();
      }
    }

    if(detectChanges) {
      _cdr.markForCheck();
      _cdr.detectChanges();
    }
  }


  void _init() {
    _viewportElement = new _ViewportElement(viewportElRef.nativeElement as Element);
    _scrollWrapper = new _ScrollWrapperElement(wrapper.nativeElement as Element);
    _viewportModels = new _Viewport(_taskBatchSize);
  }
}

typedef void Action();

class Debouncer {
  static const Duration _timeout = const Duration(milliseconds: 10);
  final Action foo;
  Timer timer;

  Debouncer(this.foo);

  void exec() {
    if(timer != null) timer.cancel();
    timer = new Timer(_timeout, foo);
  }

  void execImmediately() {
    if(timer != null) timer.cancel();
    foo();
  }
}

class _ViewportElement {
  final Element _viewportElement;
  int _offset = 0;
  int _h = 0;

  _ViewportElement(this._viewportElement);


  void setup(CardType cardType, int tasksInVp) {
    _h = cardType.height * tasksInVp;
    offset = 0;
  }

  int get height => _h;

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

  void setup(ModelDataSource dataSource, CardType cardType) {
    _h = dataSource.length * cardType.height;
    _scrollWrapper.style.height = '${_h}px';
  }
}

class _Viewport {
  final int _size;
  ModelDataSource _dataSource;
  Iterable<TaskListModel> _models;
  int _start = 0;

  _Viewport(this._size);


  void setup(ModelDataSource dataSource) {
    _dataSource = dataSource;
    setViewportStart(0);
  }

  int get start => _start;

  Iterable<TaskListModel> get models => _models;

  Iterable<TaskListModel> setViewportStart(int startIndex) {
    _start = startIndex;
    return _models = _dataSource.getInterval(startIndex, _size).toList();
  }

}