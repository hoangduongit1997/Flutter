import 'dart:async';
import 'dart:io';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Validations {
  static Future<bool> IsLogin() async {
    try {
      Future<SharedPreferences> _sp = SharedPreferences.getInstance();
      SharedPreferences prefs = await _sp.timeout(const Duration(seconds: 5));
      String key = prefs.getString('auth_token');
      if (key == null) {
        return false;
      } else {
        Configs.idUser = prefs.getString("id");
        Configs.tokenUser = key;
        return true;
      }
    } catch (e) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in valdation isLogin');
      FlutterCrashlytics().logException(e, e.stackTrace);
      return false;
    }
  }

  static bool is_Url(String text) {
    RegExp reg = new RegExp(
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
        caseSensitive: false);
    if (reg.hasMatch(text)) {
      return true;
    }
    return false;
  }

  static Future<bool> isConnectedNetwork() async {
    bool status = false;

    try {
      final result = await InternetAddress.lookup('unionist.pikatech.vn')
          .timeout(const Duration(seconds: 20));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        status = true;
        return status;
      }
    } on SocketException catch (_) {
      status = false;
      return status;
    }
    return status;
  }

  static bool isValidUser(String user) {
    return user != null && user.length > 0;
  }

  static bool IsValidPass(String pass) {
    return pass != null && pass.length > 0;
  }

  static bool IsValidConfirmPass(String pass, String confirmpass) {
    return confirmpass != null && confirmpass.length > 0 && pass == confirmpass;
  }

  static bool IsValidTitle(String title) {
    return title != null && title.length > 0;
  }

  static bool IsValidTimeStart(String timestart) {
    return timestart != null && timestart.length > 0;
  }

  static bool IsValidTimeEnd(String timeend) {
    return timeend != null && timeend.length > 0;
  }

  static bool IsValidNumber(int number) {
    return number != null && number >= 0;
  }

  static bool IsValidPhoneNumber(String number) {
    return number != null &&
        number.length == 10 &&
        !number.contains(",") &&
        !number.contains(".");
  }

  static bool IsValidAt(String at) {
    return at != null && at.length > 0;
  }

  static bool IsValidAddress(String address) {
    return address != null && address.length > 0;
  }

  static bool IsValidContain(String contain) {
    return contain != null && contain.length > 0;
  }

  static bool IsValidEmail(String email) {
    RegExp reg = new RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return reg.hasMatch(email);
  }

  static check_language() async {
    SharedPreferences check = await SharedPreferences.getInstance();
    String language_code = check.getString('pika_maintenance_language');
    if (language_code == 'vi')
      return 1;
    else if (language_code == 'en') {
      return 0;
    }
  }

  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
