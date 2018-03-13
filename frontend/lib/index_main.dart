import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/app_component.dart';
import 'package:frontend/src/dal/session.dart';


Future<Null> indexMain(Function initReflector) async {
  final session = Session.instance;
  if(!session.hasToken()) {
    html.window.location.href = '/login.html';
    return;
  }


  bootstrapStatic(AppComponent, [/*providers*/], initReflector);

  final loadingEl = html.document.querySelector('.loading-screen');
  loadingEl.style.opacity = '0';
  // animate
  await new Future.delayed(const Duration(milliseconds: 450));
  loadingEl.remove();
}
