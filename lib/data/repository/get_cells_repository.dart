import 'dart:convert';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/model/cell_model.dart';

Future<List<CellModel>> GetCellsRepository(int lineId) async {
  try {
    Map<String, dynamic> body = {
      "lineId": lineId,
      "code": "",
      "name": "",
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
        Configs.isDebugMode ? "http://testlotus.pikatech.vn:5010/getcells" : "http://lotus.pikatech.vn:5020/getcells",
        body: final_body,
        headers: {'Content-Type': 'application/json'});
    if (json.decode(response.body)['code'] == 200) {
      return CellModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in get cell res');

    return null;
  }
}
