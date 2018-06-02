import 'package:w4p_core/src/linked_tree.dart';
import 'package:w4p_core/src/visit_children_predicate.dart';


class BackwardTreeIterable<T extends LinkedTreeEntry<T>> extends Iterable<T> {
  final LinkedTree<T> _tree;
  final VisitChildrenPredicate<T> _visitChildren;
  final T _fromNode;

  BackwardTreeIterable(this._tree, this._visitChildren, this._fromNode);

  @override
  Iterator<T> get iterator => new _BackwardTreeIterator<T>(_tree, _visitChildren, _fromNode);
}

class _BackwardTreeIterator<T extends LinkedTreeEntry<T>> implements Iterator<T> {
  final LinkedTree<T> _tree;
  final VisitChildrenPredicate<T> _visitChildren;
  final T _fromNode;
  T _current;

  _BackwardTreeIterator(this._tree, this._visitChildren, [this._fromNode]);


  @override
  T get current => _current;

  @override
  bool moveNext() {
    if(_current == null) {
      _current = _fromNode;
      return true;

    } else {
      if(_current.previous != null) {
        final prev = _current.previous;

        if(!_visitChildren(prev)) {
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
  T _getLatestChild(T model) {
    var m = model;

    while(m.children.isNotEmpty && _visitChildren(m)) {
      m = m.children.last;
    }

    return m;
  }
}
