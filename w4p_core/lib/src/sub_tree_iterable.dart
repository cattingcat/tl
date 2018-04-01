import 'package:w4p_core/src/linked_tree.dart';
import 'package:w4p_core/src/visit_children_predicate.dart';


class SubTreeIterable<T extends LinkedTreeEntry<T>> extends Iterable<T> {
  final T _subTreeRoot;
  final VisitChildrenPredicate<T> _visitChildren;

  SubTreeIterable(this._subTreeRoot, this._visitChildren);


  @override
  Iterator<T> get iterator => new _SubTreeIterator<T>(_subTreeRoot, _visitChildren);
}

class _SubTreeIterator<T extends LinkedTreeEntry<T>> implements Iterator<T> {
  final T _node;
  final VisitChildrenPredicate<T> _visitChildren;
  T _current;

  _SubTreeIterator(this._node, this._visitChildren);


  @override
  T get current => _current;

  @override
  bool moveNext() {
    if(_current == null) {
      _current = _node;
      return true;
    } else {
      if(_current.children.isNotEmpty && (_visitChildren(_current) || _current == _node)) {
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
