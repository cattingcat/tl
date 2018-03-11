import 'dart:collection';

import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/task_list_component/utils/tree_iterable.dart';

class ViewportModels {
  final LinkedTree<TaskListModel> _tree;

  TaskListModel _start, _end;
  final _models = new Queue<TaskListModel>();

  ViewportModels(this._tree);


  Iterable<TaskListModel> get models => _models;

  void takeFrontWhile(bool test(TaskListModel model)) {
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

  void takeBackWhile(bool test(TaskListModel model)) {
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

  void removeFrontWhile(bool test(TaskListModel model)) {
    bool b = true;
    do {
      b = test(_models.last);
      if(b) _models.removeLast();
    } while(b && _models.isNotEmpty);

    _setAnchors();
  }

  void removeBackWhile(bool test(TaskListModel model)) {
    bool b = true;
    do {
      b = test(_models.first);
      if(b) _models.removeFirst();
    } while(b && _models.isNotEmpty);

    _setAnchors();
  }

  void retakeWhile(bool test(TaskListModel model)) {
    final treeIterable = new TreeIterable.forward(_tree, _start);
    _models.clear();

    for(var model in treeIterable) {
      if(test(model)) {
        _models.addLast(model);
      } else {
        break;
      }
    }

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

