import 'package:w4p_core/src/linked_tree.dart';
import 'package:w4p_core/src/visit_children_predicate.dart';

class ForwardTreeIterable<T extends LinkedTreeEntry<T>> extends Iterable<T> {
  final LinkedTree<T> _tree;
  final VisitChildrenPredicate<T> _visitChildren;
  final T _fromNode;

  ForwardTreeIterable(this._tree, this._visitChildren, [this._fromNode]);

  @override
  Iterator<T> get iterator => new _ForwardTreeIterator<T>(_tree, _visitChildren, _fromNode);
}

class _ForwardTreeIterator<T extends LinkedTreeEntry<T>> implements Iterator<T> {
  final LinkedTree<T> _tree;
  final VisitChildrenPredicate<T> _visitChildren;
  final T _fromNode;
  T _current;

  _ForwardTreeIterator(this._tree, this._visitChildren, [this._fromNode]);


  @override
  T get current => _current;

  @override
  bool moveNext() {
    if(_current == null) {
      _current = _fromNode ?? _tree.children.first;
      return true;
    } else {
      if(_current.children.isNotEmpty && _visitChildren(_current)) {
        _current = _current.children.first;
        return true;
      } else {
        if(_current.next != null) {
          _current = _current.next;
          return true;
        } else {
          final nextParent = _getNextParentNeighbor(_current);
          if(nextParent != null) {
            _current = nextParent;
            return true;
          } else {
            return false;
          }
        }
      }
    }
  }

  
  T _getNextParentNeighbor(T model) {
    T parent = model;
    do {
      parent = parent.parent;
    } while(parent != null && parent.next == null);

    return parent?.next;
  }
}
