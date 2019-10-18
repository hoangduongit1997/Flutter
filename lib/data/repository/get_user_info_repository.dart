import 'dart:convert';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/model/user_model.dart';

Future GetUserInfoRepository(String id_user, String token_user) async {
  try {
    Map<String, dynamic> body = {"auth_token": token_user, "id": id_user, "app": Configs.appId};
    var final_data = json.encode(body);
    post(
        Configs.isDebugMode
            ? "http://testlotus.pikatech.vn:5010/getuserinfo"
            : "http://lotus.pikatech.vn:5020/getuserinfo",
        body: final_data,
        headers: {'Content-Type': 'application/json'}).then((va) {
      Configs.user = UserModel.fromJson(json.decode(va.body));
      Configs.userDao.updateUser(Configs.user);
    });
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in get user info res');
    return null;
  }
}
