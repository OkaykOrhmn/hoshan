import 'package:equatable/equatable.dart';

import '../../../../../data/model/ai/send_message_model.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageRequest extends SendMessageEvent {
  final SendMessageModel request;

  const SendMessageRequest({required this.request});

  @override
  List<Object> get props => [request];
}

class SendMessageLocal extends SendMessageEvent {
  final SendMessageModel sendMessageModel;

  const SendMessageLocal(this.sendMessageModel);

  @override
  List<Object> get props => [sendMessageModel];
}
