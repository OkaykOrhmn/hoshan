import 'package:equatable/equatable.dart';

import '../../../../../data/model/send_message_model.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageRequest extends SendMessageEvent {
  final SendMessageModel sendMessageModel;

  const SendMessageRequest(this.sendMessageModel);

  @override
  List<Object> get props => [sendMessageModel];
}

class SendMessageLocal extends SendMessageEvent {
  final SendMessageModel sendMessageModel;

  const SendMessageLocal(this.sendMessageModel);

  @override
  List<Object> get props => [sendMessageModel];
}
