class SendMessageModel {
  String? model;
  String? query;
  int? botId;
  int? id;
  bool? fromBot;

  SendMessageModel({this.model, this.query, this.botId, this.id, this.fromBot});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    query = json['query'];
    botId = json['bot_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model;
    data['query'] = query;
    data['bot_id'] = botId;
    data['id'] = id;
    return data;
  }

  SendMessageModel copyWith(
      {String? model, String? query, int? botId, int? id, bool? fromBot}) {
    return SendMessageModel(
      model: model ?? this.model,
      query: query ?? this.query,
      botId: botId ?? this.botId,
      id: id ?? this.id,
      fromBot: fromBot ?? this.fromBot,
    );
  }
}
