import 'dart:convert';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';

import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

Future<int> CreateLineRepository(String code_name) async {
  try {
    Map<String, dynamic> body = {
      "code": code_name,
      "name": code_name,
      "centerCode": Configs.user.centerCode ?? "1",
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
      Configs.isDebugMode ? "http://testlotus.pikatech.vn:5010/newlines" : "http://lotus.pikatech.vn:5020/newlines",
      body: final_body,
      headers: {'Content-Type': 'application/json'},
    );
    var data = json.decode(response.body);
    if (data['code'] == 200) {
      return 1;
    } else {
      return 0;
    }
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in create line res');

    return 0;
  }
}