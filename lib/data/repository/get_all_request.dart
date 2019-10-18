import 'dart:convert';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/request_model.dart';

Future<List<RequestModel>> GetAllRequest({int wt = 0}) async {
  try {
    Map<String, dynamic> body = {"wt": wt, "id": Configs.idUser, "auth_token": Configs.tokenUser, "app": Configs.appId};
    var final_body = json.encode(body);
    Response response = await post(
        Configs.isDebugMode
            ? "http://testlotus.pikatech.vn:5010/getRequestAll"
            : "http://lotus.pikatech.vn:5020/getRequestAll",
        body: final_body,
        headers: {'Content-Type': 'application/json'});
    if (json.decode(response.body)['code'] == 200) {
      return RequestModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in get all request');

    return null;
  }
}
