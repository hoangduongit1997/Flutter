import 'dart:convert';
import 'dart:io';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'get_user_info_repository.dart';

Future<int> LoginRepository(String username, String pass) async {
  try {
    Map body = {
      "id": username,
      "password": pass,
      "platform": Platform.operatingSystem.toString().toUpperCase(),
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
        Configs.isDebugMode ? "http://testlotus.pikatech.vn:5010/login" : "http://lotus.pikatech.vn:5020/login",
        body: final_body,
        headers: {'Content-Type': 'application/json'});
    var data = json.decode(response.body);
    if (data['code'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("auth_token", data['data']['login']['auth_token'].toString());
      preferences.setString("id", data['data']['login']['id'].toString());
      preferences.setString("username", username);
      preferences.setString('password', pass);
      preferences.setString("login_time", DateTime.now().toString());
      Configs.tokenUser = data['data']['login']['auth_token'].toString();
      Configs.idUser = data['data']['login']['id'].toString();
      await GetUserInfoRepository(Configs.idUser, Configs.tokenUser);
      return 1;
    } else if (data['code'] == 400) {
      return -1;
    } else {
      return 0;
    }
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in login res');
    return 0;
  }
}
