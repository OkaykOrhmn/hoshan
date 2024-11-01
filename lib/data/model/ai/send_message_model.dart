import 'package:cross_file/cross_file.dart';

class SendMessageModel {
  int? id;
  String? model;
  String? query;
  int? botId;
  bool? retry;
  XFile? file;

  SendMessageModel(
      {this.id, this.model, this.query, this.botId, this.retry, this.file});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['model'];
    query = json['query'];
    botId = json['bot_id'];
    retry = json['retry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['query'] = query;
    data['bot_id'] = botId;
    data['retry'] = retry ?? false;
    return data;
  }
}
