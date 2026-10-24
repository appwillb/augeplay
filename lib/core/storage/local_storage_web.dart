import 'dart:html' as html;

class LocalStoragePlatform {
  static void setString(String key, String value) {
    try {
      html.window.localStorage[key] = value;
    } catch (e) {
      html.window.console.warn('LocalStoragePlatform error setting $key: $e');
    }
  }

  static String? getString(String key) {
    try {
      return html.window.localStorage[key];
    } catch (e) {
      html.window.console.warn('LocalStoragePlatform error getting $key: $e');
      return null;
    }
  }

  static void remove(String key) {
    try {
      html.window.localStorage.remove(key);
    } catch (_) {}
  }
}
