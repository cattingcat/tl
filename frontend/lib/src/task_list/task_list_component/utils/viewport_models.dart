import 'dart:collection';

import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/task_list_component/utils/tree_iterable.dart';

class ViewportModels {
  final LinkedTree<TaskListModelBase> _tree;

  TaskListModelBase _start, _end;
  final _models = new Queue<TaskListModelBase>();

  ViewportModels(this._tree);


  Iterable<TaskListModelBase> get models => _models;

  void takeFrontWhile(bool test(TaskListModelBase model)) {
    final treeIterable = new TreeIterable.forward(_tree, _end);
    final iterable = _end == null ? treeIterable : treeIterable.skip(1);

    for(var model in iterable) {
      if(test(model)) {
        _models.addLast(model);
      } else {
        break;
      }
    }

    _setAnchors();
  }

  void takeBackWhile(bool test(TaskListModelBase model)) {
    assert(_start != null, 'call Take front before');

    final iterable = new TreeIterable.backward(_tree, _start).skip(1);
    for(var model in iterable) {
      if(test(model)) {
        _models.addFirst(model);
      } else {
        break;
      }
    }

    _setAnchors();
  }

  void removeFrontWhile(bool test(TaskListModelBase model)) {
    bool b = true;
    do {
      b = test(_models.last);
      if(b) _models.removeLast();
    } while(b && _models.isNotEmpty);

    _setAnchors();
  }

  void removeBackWhile(bool test(TaskListModelBase model)) {
    bool b = true;
    do {
      b = test(_models.first);
      if(b) _models.removeFirst();
    } while(b && _models.isNotEmpty);

    _setAnchors();
  }

  void reset() {
    _start = _end = null;
    _models.clear();
  }


  void _setAnchors() {
    if(_models.isEmpty) {
      _start = _end = null;
    } else {
      _start = _models.first;
      _end = _models.last;
    }
  }
}

