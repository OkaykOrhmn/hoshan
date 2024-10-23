import 'package:hoshan/data/model/bots_model.dart';

class ChatsHistoryModel {
  List<Chats>? chats;

  ChatsHistoryModel({this.chats});

  ChatsHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  int? id;
  String? title;
  String? createdAt;
  Bots? bot;

  Chats({this.id, this.title, this.createdAt, this.bot});

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    bot = json['bot'] != null ? Bots.fromJson(json['bot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['created_at'] = createdAt;
    if (bot != null) {
      data['bot'] = bot!.toJson();
    }
    return data;
  }

  Chats copyWith({int? id, String? title, String? createdAt, Bots? bot}) {
    return Chats(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      bot: bot ?? this.bot,
    );
  }
}
