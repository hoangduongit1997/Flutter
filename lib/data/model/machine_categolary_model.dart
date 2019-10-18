import 'package:floor/floor.dart';

@entity
class MachineCategolaryModel {
  @PrimaryKey(autoGenerate: false)
  int id;
  String name;
  String code;
  String img_Url;
  String imageData;
  double wt;
  MachineCategolaryModel(this.id, this.name, this.code, this.img_Url, this.imageData, this.wt);
  static List<MachineCategolaryModel> fromJson(Map<String, dynamic> json) {
    List<MachineCategolaryModel> rs = new List();
    var results = json['data']['MachineCategory'] as List;
    for (var item in results) {
      var timeline = new MachineCategolaryModel(
          item['id'] == null ? null : item['id'] as int,
          item['name'] == null ? "" : item['name'] as String,
          item['code'] == null ? "" : item['code'] as String,
          item['img_Url'] == null ? "" : item['img_Url'] as String,
          null,
          null);
      rs.add(timeline);
    }

    return rs;
  }
}
