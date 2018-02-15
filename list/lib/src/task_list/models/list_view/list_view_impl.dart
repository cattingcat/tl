import 'dart:async';
import 'package:list/src/task_list/models/list_view/events.dart';
import 'package:list/src/task_list/models/list_view/list_view.dart';
import 'package:list/src/task_list/models/model_tree_manager/sublist_stats.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Flat representation of Model-tree
class ListViewImpl implements ListView {
  final _updateCtrl = new StreamController<ListViewEvent>();
  final _addCtrl = new StreamController<ListViewAddRemoveEvent>();
  final _removeCtrl = new StreamController<ListViewAddRemoveEvent>();

  final List<TaskListModelBase> _models;

  ListViewImpl(this._models);


  void addModelsAfter(int index, SublistStats subListInfo) {
    _models.insertAll(index + 1, subListInfo.list);

    final event = new ListViewAddRemoveEvent(index + 1, _models[index], subListInfo, updateAnchor: true);
    _addCtrl.add(event);
  }

  void removeModelsAfter(int index, SublistStats subListInfo) {
    final count = subListInfo.list.length;
    _models.removeRange(index + 1, index + count + 1);

    final event = new ListViewAddRemoveEvent(index + 1, _models[index], subListInfo, updateAnchor: true);
    _removeCtrl.add(event);
  }


  @override
  Stream<ListViewAddRemoveEvent> get onAdd => _addCtrl.stream;

  @override
  Stream<ListViewAddRemoveEvent> get onRemove => _removeCtrl.stream;

  @override
  Stream<ListViewEvent> get onUpdate => _updateCtrl.stream;

  @override
  int get length => _models.length;

  @override
  Iterable<TaskListModelBase> get models => _models;

  @override
  Iterable<TaskListModelBase> getRange(int start, int end) {
    return _models.getRange(start, end);
  }

  @override
  int indexOf(TaskListModelBase model) {
    return _models.indexOf(model);
  }

  @override
  Iterable<TaskListModelBase> takeWhileFrom(int index, Direction direction, bool test(TaskListModelBase model)) sync* {
    if(direction == Direction.Forward) {
      for(int i = index; i < _models.length; ++i) {
        final model = _models[i];
        if(test(model)) {
          yield model;
        } else {
          break;
        }
      }

    } else if(direction == Direction.Backward) {
      for(int i = index; i > 0; --i) {
        final model = _models[i];
        if(test(model)) {
          yield model;
        } else {
          break;
        }
      }

    } else {
      assert(false, 'Incorrect direction');
      yield* const Iterable<TaskListModelBase>.empty();
    }
  }
}