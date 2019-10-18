import 'dart:convert';

class MachineInfoHistory {
  int id;
  String code;
  String name;
  String machineCateCode;
  String cellCode;
  String location;
  List<Request> request;

  MachineInfoHistory({
    this.id,
    this.code,
    this.name,
    this.machineCateCode,
    this.cellCode,
    this.location,
    this.request,
  });

  static List<MachineInfoHistory> fromJson(Map<String, dynamic> json) {
    List<MachineInfoHistory> rs = new List();
    var results = json['data']['Machine'];
    for (var item in results) {
      MachineInfoHistory temp = new MachineInfoHistory(
        id: item["id"] == null ? null : item["id"],
        code: item["code"] == null ? "" : item["code"],
        name: item["name"] == null ? "" : item["name"],
        machineCateCode: item["machineCateCode"] == null ? "" : item["machineCateCode"],
        cellCode: item["cellCode"] == null ? "" : item["cellCode"],
        location: item["location"] == null ? "" : item["location"],
        request: item["request"] == null ? null : List<Request>.from(item["request"].map((x) => Request.fromJson(x))),
      );
      rs.add(temp);
    }
    return rs;
  }

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "machineCateCode": machineCateCode == null ? null : machineCateCode,
        "cellCode": cellCode == null ? null : cellCode,
        "location": location == null ? null : location,
        "request": request == null ? null : List<dynamic>.from(request.map((x) => x.toJson())),
      };
}

class Request {
  int machineRqId;
  String description;
  dynamic newCellCode;
  dynamic newLocation;
  List<RequestProcessing> requestProcessing;

  Request({
    this.machineRqId,
    this.description,
    this.newCellCode,
    this.newLocation,
    this.requestProcessing,
  });

  factory Request.fromRawJson(String str) => Request.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        machineRqId: json["machineRQId"] == null ? null : json["machineRQId"],
        description: json["description"] == null ? "" : json["description"],
        newCellCode: json["newCellCode"],
        newLocation: json["newLocation"],
        requestProcessing: json["requestProcessing"] == null
            ? null
            : List<RequestProcessing>.from(json["requestProcessing"].map((x) => RequestProcessing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "machineRQId": machineRqId == null ? null : machineRqId,
        "description": description == null ? null : description,
        "newCellCode": newCellCode,
        "newLocation": newLocation,
        "requestProcessing":
            requestProcessing == null ? null : List<dynamic>.from(requestProcessing.map((x) => x.toJson())),
      };
}

class RequestProcessing {
  double date;
  int requestStatus;
  String requestStatusName;
  int machineStatus;
  MachineStatusName machineStatusName;

  RequestProcessing({
    this.date,
    this.requestStatus,
    this.requestStatusName,
    this.machineStatus,
    this.machineStatusName,
  });

  factory RequestProcessing.fromRawJson(String str) => RequestProcessing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestProcessing.fromJson(Map<String, dynamic> json) => RequestProcessing(
        date: json["date"] == null ? null : json["date"],
        requestStatus: json["requestStatus"] == null ? null : json["requestStatus"],
        requestStatusName: json["requestStatusName"] == null ? "" : json["requestStatusName"],
        machineStatus: json["machineStatus"] == null ? null : json["machineStatus"],
        machineStatusName:
            json["machineStatusName"] == null ? null : machineStatusNameValues.map[json["machineStatusName"]],
      );

  Map<String, dynamic> toJson() => {
        "date": date == null ? null : date,
        "requestStatus": requestStatus == null ? null : requestStatus,
        "requestStatusName": requestStatusName == null ? null : requestStatusName,
        "machineStatus": machineStatus == null ? null : machineStatus,
        "machineStatusName": machineStatusName == null ? null : machineStatusNameValues.reverse[machineStatusName],
      };
}

enum MachineStatusName { NO_USED, RUNNING, STOP, BROKEN, MOVING, NEW }

final machineStatusNameValues = EnumValues({
  "Broken": MachineStatusName.BROKEN,
  "No Used": MachineStatusName.NO_USED,
  "Running": MachineStatusName.RUNNING,
  "Stop": MachineStatusName.STOP,
  "Moving": MachineStatusName.MOVING,
  "New": MachineStatusName.NEW
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
