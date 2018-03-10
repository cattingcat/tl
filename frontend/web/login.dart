import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

Future<Null> main() async {
  final location = html.window.location;
  final search = location.search;

  final codePattern = 'code=';
  final codeIndex = search.indexOf(codePattern);

  if(codeIndex == -1) {
    // Unauthorized
    return;
  }

  final sessionCode = location.search.substring(codeIndex + codePattern.length);
  final data = {
    'client_id': '',
    'client_secret': '',
    'code': sessionCode,
    'accept': 'json'
  };

  final requestJson = json.encode(data);

  final resp = await html.HttpRequest.request(
    'https://github.com/login/oauth/access_token',
    method: 'POST',
    sendData: requestJson,
    requestHeaders: const {'Content-Type':'application/json'});

  print(resp);
}