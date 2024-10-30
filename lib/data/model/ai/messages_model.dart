import 'package:cross_file/cross_file.dart';
import 'package:hoshan/data/model/ai/bots_model.dart';

class MessagesModel {
  int? id;
  String? title;
  String? createdAt;
  Bots? bot;
  List<Messages>? messages;

  MessagesModel({this.id, this.title, this.createdAt, this.bot, this.messages});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    bot = json['bot'] != null ? Bots.fromJson(json['bot']) : null;
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['created_at'] = createdAt;
    if (bot != null) {
      data['bot'] = bot!.toJson();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? id;
  String? content;
  String? role;
  String? fileUrl;
  bool? like;
  bool? fromBot;
  XFile? file;

  Messages({this.id, this.content, this.role, this.like, this.file}) {
    fromBot = (role == 'ai');
    // _getFile();
  }

  // Future<void> _getFile() async {
  //   file = await ChatbotRepository.createXFileFromUrl(fileUrl ?? '');
  // }

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    role = json['role'];
    like = json['like'];
    fromBot = role == 'ai';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['role'] = role;
    data['like'] = like;
    return data;
  }

  Messages copyWith(
      {String? id, String? content, String? role, bool? like, XFile? file}) {
    return Messages(
      id: id ?? this.id,
      content: content ?? this.content,
      like: like ?? this.like,
      role: role ?? this.role,
      file: file ?? this.file,
    );
  }
}
