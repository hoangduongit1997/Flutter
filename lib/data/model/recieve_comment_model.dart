class RecieveCommentModel {
  int id;
  double date;
  int requestId;
  String comment;
  int cUserId;
  String cUserName;
  int machineStatus;
  String machineStatusName;
  int status;
  String statusName;
  String url;
  String url_avt;
  RecieveCommentModel(
      {this.id,
      this.date,
      this.requestId,
      this.comment,
      this.cUserId,
      this.cUserName,
      this.machineStatus,
      this.machineStatusName,
      this.status,
      this.statusName,
      this.url,
      this.url_avt});

  static List<RecieveCommentModel> fromJson(Map<String, dynamic> json) {
    List<RecieveCommentModel> rs = new List();
    var results = json['data']['MachineReqCmd'] as List;
    for (var item in results) {
      var cell = new RecieveCommentModel(
          id: item['id'] == null ? null : item['id'] as int,
          date: item['date'] == null ? 0.0 : item['date'] as double,
          requestId: item['requestId'] == null ? null : item['requestId'] as int,
          comment: item['comment'] == null ? "" : item['comment'] as String,
          cUserId: item['cUserId'] == null ? null : item['cUserId'] as int,
          cUserName: item['cUserName'] == null ? "" : item['cUserName'] as String,
          machineStatus: item['machineStatus'] == null ? null : item['machineStatus'] as int,
          machineStatusName: item['machineStatusName'] == null ? "" : item['machineStatusName'] as String,
          status: item['status'] == null ? null : item['status'] as int,
          statusName: item['statusName'] == null ? "" : item['statusName'] as String,
          url: item['url'] == null ? "" : item['url'] as String,
          url_avt: item['url_avt'] == null ? "" : item['url_avt'] as String);
      rs.add(cell);
    }

    return rs;
  }
}
