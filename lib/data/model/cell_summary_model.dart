class CellSummaryModel {
  int cellId;
  String code;
  int cateId;
  int lineId;
  int totalMachine;
  int totalMachineBroken;
  int wt;
  bool selected; // dùng để tô màu border cell có loại máy khi nhấn vào list loại máy
  CellSummaryModel(
      {this.cellId,
      this.code,
      this.lineId,
      this.totalMachine,
      this.totalMachineBroken,
      this.wt,
      this.cateId,
      this.selected = false});
  static List<CellSummaryModel> fromJson(Map<String, dynamic> json) {
    List<CellSummaryModel> rs = new List();
    var results = json['data']['Cells'] as List;
    for (var item in results) {
      var cell = new CellSummaryModel(
          cellId: item["cellId"] == null ? null : item["cellId"],
          code: item["code"] == null ? "" : item["code"],
          lineId: item['lineId'] == null ? null : item['lineId'],
          totalMachine: item["totalMachine"] == null ? 0 : item["totalMachine"],
          totalMachineBroken: item['totalMachineBroken'] == null ? 0 : item['totalMachineBroken'],
          wt: item['wt'] == null ? 0 : item['wt'],
          cateId: item['cateId'] == null ? null : item['cateId'],
          selected: false);

      rs.add(cell);
    }

    return rs;
  }
}
