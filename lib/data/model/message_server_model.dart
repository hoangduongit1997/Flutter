class MessageServerModel{
  int code;
  String message;
  MessageServerModel(this.code,this.message);
  static List<MessageServerModel> fromJson(Map<String, dynamic> json)
  {
    List<MessageServerModel> rs = new List();
    var results = json['message'];
    for (var item in results) {
      var event = new MessageServerModel(
        item['code'] as int,
        item['message'] as String,
      );
      rs.add(event);
    }

    return rs;
  }
}