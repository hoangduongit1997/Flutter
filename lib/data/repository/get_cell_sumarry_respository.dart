import 'dart:convert';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:http/http.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/cell_summary_model.dart';

Future<List<CellSummaryModel>> GetCellSumarryRepository({int lineId, int wt = 0, int cateId = 0}) async {
  try {
    Map<String, dynamic> body = {
      "lineId": lineId,
      "wt": wt,
      'cateId': cateId,
      "id": Configs.idUser,
      "auth_token": Configs.tokenUser,
      "app": Configs.appId
    };
    var final_body = json.encode(body);
    Response response = await post(
        Configs.isDebugMode
            ? "http://testlotus.pikatech.vn:5010/getcellsummary"
            : "http://lotus.pikatech.vn:5020/getcellsummary",
        body: final_body,
        headers: {'Content-Type': 'application/json'});
    var data = json.decode(response.body);
    if (data['code'] == 200) {
      return CellSummaryModel.fromJson(data);
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in get cell sumary res');
    return null;
  }
}
