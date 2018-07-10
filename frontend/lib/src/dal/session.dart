import 'dart:convert';
import 'dart:html' as html;

const String accessToken = 'a_t';
const String userInfo = 'u_i';

class Session {
  static final Session instance = new Session();


  bool hasToken() {
    return html.window.localStorage.containsKey(accessToken);
  }

  Map<String, Object> getUserInfo() {
    final userInfoString = html.window.localStorage[userInfo];
    final jsonObj = json.decode(userInfoString) as Map<String, Object>;

    return jsonObj;
  }
}