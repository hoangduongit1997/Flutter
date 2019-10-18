class MachineInCellModel {
  int id;
  int cellId;
  int lineId;
  String locationInCell;
  String machineCateCode;
  String machineCode;
  String machineStatusCode;
  String machineStatusName;
  int wt;
  MachineInCellModel(this.id, this.cellId, this.lineId, this.locationInCell, this.machineCateCode, this.machineCode,
      this.machineStatusCode, this.machineStatusName, this.wt);
  static List<MachineInCellModel> fromJson(Map<String, dynamic> json) {
    List<MachineInCellModel> rs = new List();
    var results = json['data']['Cells'] as List;
    for (var item in results) {
      var event = new MachineInCellModel(
        item['id'] == null ? null : item['id'] as int,
        item['cellId'] == null ? null : item['cellId'] as int,
        item['lineId'] == null ? null : item['lineId'] as int,
        item['locationInCell'] == null ? "" : item['locationInCell'] as String,
        item['machineCateCode'] == null ? "" : item['machineCateCode'] as String,
        item['machineCode'] == null ? "" : item['machineCode'] as String,
        item['machineStatusCode'] == null ? "" : item['machineStatusCode'] as String,
        item['machineStatusName'] == null ? "" : item['machineStatusName'] as String,
        item['wt'] == null ? 0 : item['wt'] as int,
      );

      rs.add(event);
    }

    return rs;
  }
}
