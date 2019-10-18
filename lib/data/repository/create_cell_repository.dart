import 'dart:convert';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

Future<int> CreateCellRepository(String code_name, int line_id) async {
  try {
    Map<String, dynamic> body = {
      "code": code_name,
      "name": code_name,
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "lineId": line_id,
      "app":Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
      Configs.isDebugMode
          ? "http://testlotus.pikatech.vn:5010/newcells"
          : "http://lotus.pikatech.vn:5020/newcells",
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
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in create cell res');

    return 0;
  }
}
