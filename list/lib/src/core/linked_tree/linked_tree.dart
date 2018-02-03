import 'dart:collection';

class LinkedTree<E extends LinkedTreeEntry<E>> extends Iterable<E> {
  final _LinkedTreeChildren<E> _children = new _LinkedTreeChildren<E>();

  LinkedTree() {
    _children._parent = null; // root elements has no parent
    _children._tree = this;
  }

  Iterable<E> get children => _children;


  void addFirst(E entry){
    _children.addFirst(entry);
  }

  void add(E entry) {
    _children.add(entry);
  }

  void addAll(Iterable<E> entries) {
    _children.addAll(entries);
  }

  bool remove(E entry) => _children.remove(entry);

  void clear() => _children.clear();


  @override
  Iterator<E> get iterator => _children.iterator;

  @override
  E get first => _children.first;

  @override
  E get last => _children.last;

  @override
  E get single => _children.single;

  @override
  bool get isEmpty => _children.isEmpty;
}

class LinkedTreeEntry<E extends LinkedTreeEntry<E>> extends LinkedListEntry<E> {
  final _LinkedTreeChildren<E> _children = new _LinkedTreeChildren<E>();

  LinkedTreeEntry() {
    _children._parent = this;
  }


  set _tree(LinkedTree<E> value) {
    _children._tree = value;
  }


  LinkedTree<E> get tree => _children.tree;

  E get parent {
    // list == null when entry unlinked
    return (list as _LinkedTreeChildren<E>)?.parent;
  }

  Iterable<E> get children => _children;

  bool get isEmpty => _children.isEmpty;

  bool get isNotEmpty => _children.isNotEmpty;

  void addChild(E entry) {
    _children.add(entry);
  }


  @override
  void insertBefore(E entry) {
    entry._tree = tree;
    super.insertBefore(entry);
  }

  @override
  void insertAfter(E entry) {
    entry._tree = tree;
    super.insertAfter(entry);
  }

  @override
  void unlink() {
    _tree = null;
    super.unlink();
  }
}

class _LinkedTreeChildren<E extends LinkedTreeEntry<E>> extends LinkedList<E> {
  LinkedTree<E> _tree;
  E _parent;

  E get parent => _parent;

  LinkedTree<E> get tree => _tree;


  @override
  void addFirst(E entry) {
    entry._tree = tree;
    super.addFirst(entry);
  }

  @override
  void add(E entry) {
    entry._tree = tree;
    super.add(entry);
  }

  @override
  void addAll(Iterable<E> entries) {
    entries.forEach(add);
  }

  @override
  bool remove(E entry) {
    entry._tree = null;
    return super.remove(entry);
  }

  @override
  void clear() {
    forEach((i) => i._tree = null);
    super.clear();
  }
}