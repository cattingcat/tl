import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/app_component.dart';
import 'package:frontend/src/dal/session.dart';

// ignore: uri_has_not_been_generated
import 'main.template.dart' as ng;


Future<Null> main() async {
  final session = Session.instance;
  if(!session.hasToken()) {
    // TODO: OAuth and redirect to login page
    print('Unauthorized user');
  }


  bootstrapStatic(AppComponent, [/*providers*/], ng.initReflector);

  final loadingEl = html.document.querySelector('.loading');
  loadingEl.style.opacity = '0';
  // animate
  await new Future.delayed(const Duration(milliseconds: 450));
  loadingEl.remove();
}
