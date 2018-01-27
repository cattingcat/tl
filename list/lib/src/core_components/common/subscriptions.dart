import 'dart:async';

class Subscriptions extends Iterable<StreamSubscription<Object>> {
  final List<StreamSubscription<Object>> _list = new List<StreamSubscription<Object>>();

  void cancel() {
    _list.forEach((i) => i.cancel());
  }

  void clear() {
    _list.clear();
  }

  void add(StreamSubscription<Object> s) {
    _list.add(s);
  }

  void addAll(Iterable<StreamSubscription<Object>> s) {
    _list.addAll(s);
  }

  void listen<T>(Stream<T> stream, void onData(T event)) {
    _list.add(stream.listen(onData));
  }

  @override
  Iterator<StreamSubscription> get iterator => _list.iterator;
}