import 'dart:html';
import 'package:angular/angular.dart';
import 'package:list/src/task_list/task_card/task_card_component.dart';
import 'package:list/src/task_list/view_models/card_type.dart';
import 'package:list/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';

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

  final Element _hostElement;
  final ChangeDetectorRef _cdr;

  _ViewportElement _viewportElement;
  _ScrollWrapperElement _scrollWrapper;
  _Viewport _viewportModels;

  @Input() ViewModelDataSource dataSource;
  @Input() CardType cardType;

  @ViewChild('viewport') ElementRef viewportElRef;
  @ViewChild('wrapper') ElementRef wrapper;

  TaskListComponent(this._hostElement, this._cdr);


  Iterable<TaskListViewModel> get models => _viewportModels.models;

  int trackFunction(int index, TaskListViewModel model) {
    return model.text.hashCode;
  }


  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('dataSource')) {
      _init();
      final ds = changes['dataSource'].currentValue as ViewModelDataSource;
      final card = (changes.containsKey('cardType') ? changes['cardType'].currentValue : cardType) as CardType;

      _viewportModels.setup(ds);
      _viewportElement.setup(cardType, _taskBatchSize);
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
    _hostElement.addEventListener('scroll', _handleScrollEvent);
  }


  _ScrollInfo _getIndexByScroll(int scrollPx) {
    final index = (scrollPx / cardType.height).floor();
    final rest = scrollPx % cardType.height;

    return new _ScrollInfo(index, rest);
  }


  void _handleScrollEvent(Event e) {
    final scrollTop = _hostElement.scrollTop;

    final scrollInfo = _getIndexByScroll(scrollTop);

    final vpAnchor = scrollTop - scrollInfo.rest;
    final vpModelIndex = scrollInfo.index;
    print('scrollInfo: $scrollInfo, vpAnch: $vpAnchor');

    _viewportElement.offset = vpAnchor;
    _viewportModels.setViewportStart(vpModelIndex);

    _cdr.markForCheck();
    _cdr.detectChanges();
  }

  void _init() {
    _viewportElement = new _ViewportElement(viewportElRef.nativeElement as Element);
    _scrollWrapper = new _ScrollWrapperElement(wrapper.nativeElement as Element);
    _viewportModels = new _Viewport(_taskBatchSize);
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

  void setup(ViewModelDataSource dataSource, CardType cardType) {
    _h = dataSource.length * cardType.height;
    _scrollWrapper.style.height = '${_h}px';
  }
}

class _Viewport {
  final int _size;
  ViewModelDataSource _dataSource;
  Iterable<TaskListViewModel> _models;
  int _start = 0;

  _Viewport(this._size);


  void setup(ViewModelDataSource dataSource) {
    _dataSource = dataSource;
    setViewportStart(0);
  }

  int get start => _start;

  Iterable<TaskListViewModel> get models => _models;

  Iterable<TaskListViewModel> setViewportStart(int startIndex) {
    _start = startIndex;
    return _models = _dataSource.getInterval(startIndex, _size).toList();
  }

}

class _ScrollInfo {
  final int index;
  final int rest;

  _ScrollInfo(this.index, this.rest);

  @override
  String toString() => '$index + $rest px';
}