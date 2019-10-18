import 'package:floor/floor.dart';

@entity
class MachineModel {
  @PrimaryKey(autoGenerate: false)
  int machineId;
  int mCateId;
  int cell_id;
  int line_id;
  String name;
  String positition;
  String code;
  String statusCode;
  String statusName;
  double wt;
  MachineModel(this.machineId, this.mCateId, this.cell_id, this.line_id, this.positition, this.name, this.code,
      this.statusCode, this.statusName, this.wt);
  static List<MachineModel> fromJson(Map<String, dynamic> json) {
    List<MachineModel> rs = new List();
    var results = json['data']['Machine'] as List;
    for (var item in results) {
      var event = new MachineModel(
          item['id'] == null ? null : item['id'] as int,
          item['mCateId'] == null ? null : item['mCateId'] as int,
          item['cellId'] == null ? null : item['cellId'] as int,
          item['lineId'] == null ? null : item['lineId'] as int,
          item['location'] == null ? "" : item['location'] as String,
          item['name'] == null ? "" : item['name'] as String,
          item['code'] == null ? "" : item['code'] as String,
          item['statusCode'] == null ? "" : item['statusCode'] as String,
          item['statusName'] == null ? "" : item['statusName'] as String,
          null);

      rs.add(event);
    }

    return rs;
  }
}
