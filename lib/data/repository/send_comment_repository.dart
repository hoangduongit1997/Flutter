import 'dart:convert';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

Future<int> SendCommentRepository(int requestId, int status, int date, int machineStatus, String comment) async {
  try {
    Map<String, dynamic> body = {
      "requestId": requestId,
      "status": status,
      "date": date,
      "machineStatus": machineStatus,
      "comment": comment,
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
      Configs.isDebugMode
          ? "http://testlotus.pikatech.vn:5010/newmachinerequestcomment"
          : "http://lotus.pikatech.vn:5020/newmachinerequestcomment",
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
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in send comment res');
    return 0;
  }
}
