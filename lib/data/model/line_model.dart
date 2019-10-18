import 'package:floor/floor.dart';

@entity
class LineModel {
  @PrimaryKey(autoGenerate: false)
  int lineId;
  String name;
  String code;
  String centerCode;
  double wt;

  LineModel(this.lineId, this.name, this.code, this.centerCode, this.wt);
  static List<LineModel> fromJson(Map<String, dynamic> json) {
    List<LineModel> rs = new List();
    var results = json['data']['Lines'] as List;
    for (var item in results) {
      var line =
          new LineModel(item["id"] == null ? null : item["id"], item["name"]==null?"":item["name"], item['code']==null?"":item['code'], item["centerCode"]==null?"":item["centerCode"], null);
      rs.add(line);
    }

    return rs;
  }
}
