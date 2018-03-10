import 'dart:convert';
import 'dart:html' as html;

const String AccessToken = 'a_t';
const String UserInfo = 'u_i';

class Session {
  static final Session instance = new Session();


  bool hasToken() {
    return html.window.localStorage.containsKey(AccessToken);
  }

  Map<String, Object> getUserInfo() {
    final userInfoString = html.window.localStorage[UserInfo];
    final jsonObj = json.decode(userInfoString) as Map<String, Object>;

    return jsonObj;
  }
}