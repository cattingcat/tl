import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';


abstract class TreeIterable extends Iterable<TaskListModel> {
  factory TreeIterable.forward(LinkedTree<TaskListModel> tree, [TaskListModel fromNode]) => new _ForwardTreeIterable(tree, fromNode);
  factory TreeIterable.backward(LinkedTree<TaskListModel> tree, TaskListModel fromNode) => new _BackwardTreeIterable(tree, fromNode);

  factory TreeIterable.node(TaskListModel node) => new _VisibleSubNodelTreeIterable(node);
}


class _ForwardTreeIterable extends Iterable<TaskListModel> implements TreeIterable {
  final LinkedTree<TaskListModel> _tree;
  final TaskListModel _fromNode;

  _ForwardTreeIterable(this._tree, [this._fromNode]);

  @override
  Iterator<TaskListModel> get iterator => new _ForwardTreeIterator(_tree, _fromNode);
}

class _ForwardTreeIterator implements Iterator<TaskListModel> {
  final LinkedTree<TaskListModel> _tree;
  final TaskListModel _fromNode;

  _ForwardTreeIterator(this._tree, [this._fromNode])/*:
      assert(_tree != null, 'Tree should not be null')*/;


  TaskListModel _current;

  @override
  TaskListModel get current => _current;

  @override
  bool moveNext() {
    if(_current == null) {
      _current = _fromNode ?? _tree.children.first;
      return true;
    } else {
      if(_current.isExpanded && _current.children.isNotEmpty) {
        _current = _current.children.first;
        return true;
      } else {
        if(_current.next != null) {
          _current = _current.next;
          return true;
        } else {
          final parent = _current.parent;
          if(parent != null && parent.next != null) {
            _current = parent.next;
            return true;
          } else {
            return false;
          }
        }
      }
    }
  }
}


class _BackwardTreeIterable extends Iterable<TaskListModel> implements TreeIterable {
  final LinkedTree<TaskListModel> _tree;
  final TaskListModel _fromNode;

  _BackwardTreeIterable(this._tree, this._fromNode)/*:
    assert(_tree != null && _fromNode != null, 'from node required for backward iteration');*/;

  @override
  Iterator<TaskListModel> get iterator => new _BackwardTreeIterator(_tree, _fromNode);
}

class _BackwardTreeIterator implements Iterator<TaskListModel> {
  final LinkedTree<TaskListModel> _tree;
  final TaskListModel _fromNode;

  _BackwardTreeIterator(this._tree, [this._fromNode])/*:
    assert(_tree != null, 'Tree should not be null');*/;


  TaskListModel _current;

  @override
  TaskListModel get current => _current;

  @override
  bool moveNext() {
    if(_current == null) {
      _current = _fromNode;
      return true;

    } else {
      if(_current.previous != null) {
        final prev = _current.previous;

        if(!prev.isExpanded) {
          _current = prev;
          return true;
        } else {
          final latestChild = _getLatestChild(prev);
          _current = latestChild;
          return true;
        }
      } else {
        final parent = _current.parent;

        if(parent != null) {
          _current = parent;
          return true;

        } else {
          return false;
        }
      }
    }
  }


  /// Returns latest child in hierarchy
  TaskListModel _getLatestChild(TaskListModel model) {
    var m = model;

    while(m.isExpanded && m.children.isNotEmpty) {
      m = m.children.last;
    }

    return m;
  }
}


class _VisibleSubNodelTreeIterable extends Iterable<TaskListModel> implements TreeIterable {
  final TaskListModel _node;

  _VisibleSubNodelTreeIterable(this._node);


  @override
  Iterator<TaskListModel> get iterator => new _VisibleSubNodelTreeIterator(_node);
}

class _VisibleSubNodelTreeIterator implements Iterator<TaskListModel> {
  final TaskListModel _node;

  _VisibleSubNodelTreeIterator(this._node);


  TaskListModel _current;

  @override
  TaskListModel get current => _current;

  @override
  bool moveNext() {
    if(_current == null) {
      _current = _node;
      return true;
    } else {
      if((_current.isExpanded || _current == _node) && _current.children.isNotEmpty) {
        _current = _current.children.first;
        return true;
      } else {
        if(_current.next != null) {
          _current = _current.next;
          return true;
        } else {
          final parent = _current.parent;
          if(parent == _node) {
            return false;

          }else if(parent.next != null) {
            _current = parent.next;
            return true;
          } else {
            return false;
          }
        }
      }
    }
  }
}