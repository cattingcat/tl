import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';


abstract class TreeIterable extends Iterable<TaskListModelBase> {
  factory TreeIterable.forward(LinkedTree<TaskListModelBase> tree, [TaskListModelBase fromNode]) => new _ForwardTreeIterable(tree, fromNode);
  factory TreeIterable.backward(LinkedTree<TaskListModelBase> tree, TaskListModelBase fromNode) => new _BackwardTreeIterable(tree, fromNode);

  factory TreeIterable.node(TaskListModelBase node) => new _VisibleSubNodelTreeIterable(node);
}


class _ForwardTreeIterable extends Iterable<TaskListModelBase> implements TreeIterable {
  final LinkedTree<TaskListModelBase> _tree;
  final TaskListModelBase _fromNode;

  _ForwardTreeIterable(this._tree, [this._fromNode]);

  @override
  Iterator<TaskListModelBase> get iterator => new _ForwardTreeIterator(_tree, _fromNode);
}

class _ForwardTreeIterator implements Iterator<TaskListModelBase> {
  final LinkedTree<TaskListModelBase> _tree;
  final TaskListModelBase _fromNode;

  _ForwardTreeIterator(this._tree, [this._fromNode]):
      assert(_tree != null, 'Tree should not be null');


  TaskListModelBase _current;

  @override
  TaskListModelBase get current => _current;

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


class _BackwardTreeIterable extends Iterable<TaskListModelBase> implements TreeIterable {
  final LinkedTree<TaskListModelBase> _tree;
  final TaskListModelBase _fromNode;

  _BackwardTreeIterable(this._tree, this._fromNode):
    assert(_tree != null && _fromNode != null, 'from node required for backward iteration');

  @override
  Iterator<TaskListModelBase> get iterator => new _BackwardTreeIterator(_tree, _fromNode);
}

class _BackwardTreeIterator implements Iterator<TaskListModelBase> {
  final LinkedTree<TaskListModelBase> _tree;
  final TaskListModelBase _fromNode;

  _BackwardTreeIterator(this._tree, [this._fromNode]):
        assert(_tree != null, 'Tree should not be null');


  TaskListModelBase _current;

  @override
  TaskListModelBase get current => _current;

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
  TaskListModelBase _getLatestChild(TaskListModelBase model) {
    var m = model;

    while(m.isExpanded && m.children.isNotEmpty) {
      m = m.children.last;
    }

    return m;
  }
}


class _VisibleSubNodelTreeIterable extends Iterable<TaskListModelBase> implements TreeIterable {
  final TaskListModelBase _node;

  _VisibleSubNodelTreeIterable(this._node);


  @override
  Iterator<TaskListModelBase> get iterator => new _VisibleSubNodelTreeIterator(_node);
}

class _VisibleSubNodelTreeIterator implements Iterator<TaskListModelBase> {
  final TaskListModelBase _node;

  _VisibleSubNodelTreeIterator(this._node);


  TaskListModelBase _current;

  @override
  TaskListModelBase get current => _current;

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