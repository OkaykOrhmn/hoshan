class AiResponseModel {
  int? chatId;
  String? content;
  String? aiMessageId;
  String? humanMessageId;
  String? chatTitle;

  AiResponseModel(
      {this.chatId,
      this.content,
      this.aiMessageId,
      this.humanMessageId,
      this.chatTitle});

  AiResponseModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    chatTitle = json['chat_title'];
    content = json['content'];
    aiMessageId = json['ai_message_id'];
    humanMessageId = json['human_message_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['chat_title'] = chatTitle;
    data['content'] = content;
    data['ai_message_id'] = aiMessageId;
    data['human_message_id'] = humanMessageId;
    return data;
  }

  AiResponseModel copyWith(
      {int? chatId,
      String? content,
      String? aiMessageId,
      String? humanMessageId,
      String? chatTitle}) {
    return AiResponseModel(
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      aiMessageId: aiMessageId ?? this.aiMessageId,
      humanMessageId: humanMessageId ?? this.humanMessageId,
      chatTitle: chatTitle ?? this.chatTitle,
    );
  }
}
