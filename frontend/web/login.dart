import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:frontend/src/dal/session.dart';

Future<Null> main() async {
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


  // In is OAuth callback, request access token
  final requestJson = json.encode({
    'client_id': '15c07d78726cd3a00eeb',
    'client_secret': 'c66ce9f90a46d837254248929e65f6a631011284',
    'code': sessionCode,
    'accept': 'json'
  });
  final resp = await html.HttpRequest.request(
    'https://github.com/login/oauth/access_token',
    method: 'POST',
    sendData: requestJson,
    requestHeaders: {
      'Content-Type':'application/json'
    });
  final tokens = resp.responseText;
  html.window.localStorage[AccessToken] = tokens;

  // Redirect to main page after access_token response
  redirectToMain();
}

Future<Map<String, Object>> getUserInfo() async {
  final token = html.window.localStorage[AccessToken];
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
    html.window.localStorage[UserInfo] = jsonString;
    html.window.location.href = '/';
  } catch(e) {
    // Invalid access token
    html.window.localStorage.remove(AccessToken);
    rethrow;
  }
  // We already logged in, redirect to main page
  return;
}