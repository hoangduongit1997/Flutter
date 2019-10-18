import 'dart:convert';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/model/machine_categolary_model.dart';

Future<List<MachineCategolaryModel>> GetMachinesCategolaryRepository() async {
  try {
    Map<String, dynamic> body = {"id": Configs.idUser, "auth_token": Configs.tokenUser, "app": Configs.appId};
    var final_body = json.encode(body);
    Response response = await post(
        Configs.isDebugMode
            ? "http://testlotus.pikatech.vn:5010/getmachinecategorys"
            : "http://lotus.pikatech.vn:5020/getmachinecategorys",
        body: final_body,
        headers: {'Content-Type': 'application/json'});
    var data = json.decode(response.body);
    if (data['code'] == 200) {
      return MachineCategolaryModel.fromJson(data);
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(),
        priority: 200,
        tag: 'Error in get machine categolary '
            'res');

    return null;
  }
}
