class SendMessageModel {
  int? id;
  String? model;
  String? query;
  int? botId;

  SendMessageModel({this.id, this.model, this.query, this.botId});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['model'];
    query = json['query'];
    botId = json['bot_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['query'] = query;
    data['bot_id'] = botId;
    return data;
  }
}
