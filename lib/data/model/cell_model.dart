import 'package:floor/floor.dart';

@entity
class CellModel {
  @PrimaryKey(autoGenerate: false)
  int id;
  int lineId;
  String name;
  String code;
  double wt;

  CellModel(
    this.id,
    this.code,
    this.name,
    this.lineId,
    this.wt,
  );
  static List<CellModel> fromJson(Map<String, dynamic> json) {
    List<CellModel> rs = new List();
    var results = json['data']['Cells'] as List;
    for (var item in results) {
      var cell = new CellModel(item["id"] == null ? null : item["id"], item["code"] == null ? "" : item["code"],
          item['name'] == null ? "" : item['name'], item["lineId"] == null ? null : item["lineId"], null);
      rs.add(cell);
    }

    return rs;
  }
}
