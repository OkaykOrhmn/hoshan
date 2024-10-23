class AiResponseModel {
  int? chatId;
  String? content;
  String? aiMessageId;
  String? humanMessageId;

  AiResponseModel(
      {this.chatId, this.content, this.aiMessageId, this.humanMessageId});

  AiResponseModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    content = json['content'];
    aiMessageId = json['ai_message_id'];
    humanMessageId = json['human_message_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['content'] = content;
    data['ai_message_id'] = aiMessageId;
    data['human_message_id'] = humanMessageId;
    return data;
  }
}
