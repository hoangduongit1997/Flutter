import 'dart:convert';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/model/message_server_model.dart';

Future<int> DeleteLineRepository(int line_id, String code, String name) async {
  try {
    Map<String, dynamic> body = {
      "lineId": line_id,
      "name": name,
      "code": code,
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "centerCode": Configs.user.centerCode ?? "1",
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
        Configs.isDebugMode
            ? "http://testlotus.pikatech.vn:5010/removelines"
            : "http://lotus.pikatech.vn:5020/removelines",
        body: final_body,
        headers: {'Content-Type': 'application/json'});
    if (json.decode(response.body)['code'] == 200) {
      List<MessageServerModel> lst_message;
      lst_message = MessageServerModel.fromJson(json.decode(response.body));
      var result = lst_message.where((t) => t.code == 600);
      if (result.length == 0) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in delete line res');

    return 0;
  }
}
