import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:frontend/src/dal/session.dart';

Future<Null> loginMain() async {
  final session = Session.instance;
  if(session.hasToken()) {
    try {
      await redirectToMain();

      // We already logged in, redirect to main page
      return;

    } catch(e) {
      // Access token died
      return;
    }
  }


  final location = html.window.location;
  final search = location.search;
  final codePattern = 'code=';
  final codeIndex = search.indexOf(codePattern);
  if(codeIndex == -1) {
    // it is not OAuth callback, just show page
    return;
  }
  final sessionCode = location.search.substring(codeIndex + codePattern.length);


  // Enter to loading state
  final loginForm = html.document.querySelector('.login-form');
  loginForm.classes.add('hidden');
  (new Future.delayed(const Duration(milliseconds: 300))).then((_) {
    // callback after animation login-form
    loginForm.style.display = 'none';
    final loading = html.document.querySelector('.loading');
    loading.classes.remove('hidden');
  });

  // In is OAuth callback, request access token
  final requestJson = json.encode({
    'code': sessionCode
  });
  final resp = await html.HttpRequest.request(
      '/api/Login/LoginGitHub',
      method: 'POST',
      sendData: requestJson,
      requestHeaders: {
        'Content-Type':'application/json'
      });
  final token = json.decode(resp.responseText)['token'];
  html.window.localStorage[accessToken] = token;

  // Redirect to main page after access_token response
  redirectToMain();
}

Future<Map<String, Object>> getUserInfo() async {
  final token = html.window.localStorage[accessToken];
  final resp = await html.HttpRequest.request(
      'https://api.github.com/user?$token',
      method: 'GET',
      requestHeaders: {
        'Content-Type':'application/json'
      });

  return json.decode(resp.responseText);
}

Future<Null> redirectToMain() async {
  try {
    final userData = await getUserInfo();
    final jsonString = json.encode(userData);
    html.window.localStorage[userInfo] = jsonString;
    html.window.location.href = '/';
  } catch(e) {
    // Invalid access token
    html.window.localStorage.remove(accessToken);
    rethrow;
  }
  // We already logged in, redirect to main page
  return;
}