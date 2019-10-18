import 'dart:convert';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

Future<int> SendRequestRepository(int machineId, int cellid, String location, int machineStatus, String description,
    int priorityFlag, String newlocation, int newcellId) async {
  try {
    Map<String, dynamic> body = {
      "machineId": machineId,
      "date": DateTime.now().millisecondsSinceEpoch,
      "cellId": cellid,
      "location": location,
      "machineStatus": machineStatus,
      "description": description,
      "priorityFlag": priorityFlag,
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "newlocation": newlocation,
      "newcellId": newcellId,
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
      Configs.isDebugMode
          ? "http://testlotus.pikatech.vn:5010/newmachinerequest"
          : "http://lotus.pikatech.vn:5020/newmachinerequest",
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
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in send request res');
    return 0;
  }
}
