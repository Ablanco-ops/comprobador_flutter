import 'package:shared_preferences/shared_preferences.dart';

class ConfigPreferences {
  static Future<void> setPathExcel(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pathExcel', value);
  }

  static Future<String> getPathExcel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('pathExcel')) {
      return prefs.getString('pathExcel')!;
    } else {
      return '';
    }
  }
}
