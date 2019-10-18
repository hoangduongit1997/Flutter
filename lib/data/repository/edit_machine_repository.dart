import 'dart:convert';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';

import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

Future<int> EditMachineRepository(
    int line_id, int machineId, int mCateId, int cellId, String code_name, String location, String statusCode) async {
  try {
    Map<String, dynamic> body = {
      "lineId": line_id,
      "machineId": machineId,
      "mCateId": mCateId,
      "cellId": cellId,
      "code": code_name,
      "location": location,
      "name": code_name,
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "statusCode": statusCode,
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
      Configs.isDebugMode
          ? "http://testlotus.pikatech.vn:5010/editmachines"
          : "http://lotus.pikatech.vn:5020/editmachines",
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
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in edit machine res');

    return 0;
  }
}
