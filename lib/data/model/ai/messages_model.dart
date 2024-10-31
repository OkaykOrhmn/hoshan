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
  List<Content>? content;
  String? role;
  String? fileUrl;
  bool? like;
  bool? fromBot;
  XFile? file;

  Messages({this.id, this.content, this.role, this.like, this.file}) {
    fromBot = (role == 'ai');
    if (content != null && content!.isNotEmpty) {
      // Sort content list: "image" first, then "text"
      content!.sort((a, b) {
        if (a.type == 'image_url' && b.type != 'image_url') {
          return -1; // a comes before b
        } else if (a.type != 'image_url' && b.type == 'image_url') {
          return 1; // b comes before a
        }
        return 0; // maintain original order if both are the same type
      });
    }

    // _getFile();
  }

  // Future<void> _getFile() async {
  //   file = await ChatbotRepository.createXFileFromUrl(fileUrl ?? '');
  // }

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
    role = json['role'];
    like = json['like'];
    fromBot = role == 'ai';
    if (content != null && content!.isNotEmpty) {
      // Sort content list: "image" first, then "text"
      content!.sort((a, b) {
        if (a.type == 'image_url' && b.type != 'image_url') {
          return -1; // a comes before b
        } else if (a.type != 'image_url' && b.type == 'image_url') {
          return 1; // b comes before a
        }
        return 0; // maintain original order if both are the same type
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['role'] = role;
    data['like'] = like;
    return data;
  }

  Messages copyWith(
      {String? id,
      List<Content>? content,
      String? role,
      bool? like,
      XFile? file}) {
    return Messages(
      id: id ?? this.id,
      content: content ?? this.content,
      like: like ?? this.like,
      role: role ?? this.role,
      file: file ?? this.file,
    );
  }
}

class Content {
  String? type;
  String? text;
  ImageUrl? imageUrl;

  Content({this.type, this.text, this.imageUrl});

  Content.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    text = json['text'];
    imageUrl =
        json['image_url'] != null ? ImageUrl.fromJson(json['image_url']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['text'] = text;
    if (imageUrl != null) {
      data['image_url'] = imageUrl!.toJson();
    }
    return data;
  }
}

class ImageUrl {
  String? url;

  ImageUrl({this.url});
  ImageUrl.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
