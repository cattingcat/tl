import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
// ignore: uri_has_not_been_generated
import 'package:frontend/app_component.template.dart' as ng;
import 'package:frontend/src/dal/session.dart';


Future<Null> indexMain() async {
  final session = Session.instance;
  if(!session.hasToken()) {
    html.window.location.href = '/login.html';
    return;
  }

  runApp(ng.AppComponentNgFactory);

  final loadingEl = html.document.querySelector('.loading-screen');
  loadingEl.style.opacity = '0';
  // animate
  await new Future.delayed(const Duration(milliseconds: 450));
  loadingEl.remove();
}
