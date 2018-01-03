import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
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
  static const int _viewportHeight = _taskBatchSize * _cardSize;
  static const int _taskRequestCount = 5;

  final ElementRef _elementRef;
  final ChangeDetectorRef _cd;

  Debouncer _scrollDebouncer;
  int scrollWrapperHeight;

  @Input() ModelDataSource dataSource;

  @ViewChild('viewport') ElementRef viewport;
  @ViewChild('wrapper') ElementRef wrapper;

  Iterable<TaskListModel> models;

  TaskListComponent(this._elementRef, this._cd) {
    _scrollDebouncer = new Debouncer(_handleScroll);
  }


  Element get hostElement => _elementRef.nativeElement as Element;
  Element get scrollWrapperElement => wrapper.nativeElement as Element;
  Element get viewportElement => viewport.nativeElement as Element;

  int trackFunction(int index, TaskListModel model) {
    return model.text.hashCode;
  }


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    _setViewportModels(0);
    _setViewportOffset(0);

    // update scroll-wrapper size
    scrollWrapperHeight = dataSource.length * _cardSize;
    scrollWrapperElement.style.height = '${scrollWrapperHeight}px';

    // update scroll position
    _scrollTop = _prevScroll = hostElement.scrollTop = 0;
  }

  @override
  void ngAfterViewInit() {
    hostElement.addEventListener('scroll', _handleScrollEvent);
  }


  int _scrollTop = 0;
  int _prevScroll = 0;
  void _handleScrollEvent(Event e) {
    _scrollTop = hostElement.scrollTop;

    if((_scrollTop - _prevScroll).abs() > _viewportHeight) {
      _scrollDebouncer.execImmediately();
    } else {
      _scrollDebouncer.exec();
    }

    _prevScroll = _scrollTop;
  }

  void _handleScroll() {
    final clientHeight = hostElement.clientHeight;

    final clientCenter = _scrollTop + clientHeight / 2;
    final viewportCenter = _viewportOffset + _viewportHeight / 2;

    final diff = clientCenter - viewportCenter;
    final cardDiff = diff / _cardSize;

    final newOffset = _viewportOffset + diff;
    final newModelIndex = _viewportModelStart + cardDiff.floor();

    bool detectChanges = false;
    if(cardDiff > _taskRequestCount) {
      final index = newModelIndex + _taskBatchSize > dataSource.length ? dataSource.length - _taskBatchSize : newModelIndex;
      if(index != _viewportModelStart) {
        _setViewportModels(index);
        detectChanges = true;

        final offset = newOffset > scrollWrapperHeight ? scrollWrapperHeight - _viewportHeight : newOffset;
        _setViewportOffset(offset.toInt());
      }

    } else if(cardDiff < -_taskRequestCount) {
      final index = newModelIndex > 0 ? newModelIndex : 0;
      if(index != _viewportModelStart) {
        _setViewportModels(index);
        detectChanges = true;


        final offset = newOffset > 0 ? newOffset : 0;
        _setViewportOffset(offset.toInt());
      }
    }

    if(detectChanges) {
      _cd.markForCheck();
      _cd.detectChanges();
    }
  }


  int _viewportModelStart = 0;
  void _setViewportModels(int startIndex) {
    _viewportModelStart = startIndex;
    models = dataSource.getInterval(_viewportModelStart, _taskBatchSize).toList();
  }

  int _viewportOffset = 0;
  void _setViewportOffset(int offset) {
    _viewportOffset = offset;
    viewportElement.style.transform = 'translate(0px, ${offset}px)';
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