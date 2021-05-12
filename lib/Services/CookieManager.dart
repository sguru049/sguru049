// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:botox_deals/Constants/StringConstants.dart';

class CookieManager {
  static addToCookie(String key, String value) {
    // 31536000 sec = 365 days.
    html.document.cookie = "$key=$value; max-age=31536000; path=/;";
  }

  static deleteCookie(String name) {
    html.document.cookie =
        "$name=; Path=/; expires=Thu, 18 Dec 1970 12:00:00 UTC;";
  }

  static String getCookie(String key) {
    String cookies = html.document.cookie!;
    List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : [];
    String matchVal = "";
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    return matchVal;
  }

  static bool isUserLoggedIn() {
    final sessionId = CookieManager.getCookie(skUserAccessToken);
    print('sessionId = $sessionId');
    return (sessionId.isNotEmpty) ? true : false;
  }
}
