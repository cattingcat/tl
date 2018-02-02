import 'dart:async';

typedef void Action();

class Debouncer {
  static const Duration _timeout = const Duration(milliseconds: 10);
  final Action foo;
  Timer timer;

  Debouncer(this.foo);

  void exec() {
    if(timer != null) timer.cancel();
    timer = new Timer(_timeout, foo);
  }

  void execImmediately() {
    if(timer != null) timer.cancel();
    foo();
  }
}