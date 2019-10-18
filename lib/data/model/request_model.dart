class RequestModel {
  int requestId;
  double cTime;
  String description;
  String inputtedTime;
  double requestDate;
  int cellId;
  int statusCode;
  String statusName;
  int machineStatusCode;
  String machineStatusName;
  String machineCateCode;
  String machineCode;
  int totalComment;
  RequestModel(
      this.requestId,
      this.cTime,
      this.description,
      this.inputtedTime,
      this.requestDate,
      this.cellId,
      this.statusCode,
      this.statusName,
      this.machineStatusCode,
      this.machineStatusName,
      this.machineCateCode,
      this.machineCode,
      this.totalComment);

  static List<RequestModel> fromJson(Map<String, dynamic> json) {
    List<RequestModel> rs = new List();
    var results = json['data']['MachineReq'];
    for (var item in results) {
      var event = new RequestModel(
        item['requestId'] == null ? null : item['requestId'] as int,
        item['cTime'] == null ? 0.0 : item['cTime'] as double,
        item['description'] == null ? "" : item['description'] as String,
        item['inputtedTime'] == null ? "" : item['inputtedTime'] as String,
        item['requestDate'] == null ? 0.0 : item['requestDate'] as double,
        item['cellId'] == null ? null : item['cellId'] as int,
        item['statusCode'] == null ? null : item['statusCode'] as int,
        item['statusName'] == null ? "" : item['statusName'] as String,
        item['machineStatusCode'] == null ? null : item['machineStatusCode'] as int,
        item['machineStatusName'] == null ? "" : item['machineStatusName'] as String,
        item['machineCateCode'] == null ? "" : item['machineCateCode'] as String,
        item['machineCode'] == null ? "" : item['machineCode'] as String,
        item['totalComment'] == null ? 0 : item['totalComment'] as int,
      );
      rs.add(event);
    }

    return rs;
  }
}
