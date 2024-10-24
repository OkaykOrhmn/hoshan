import 'package:equatable/equatable.dart';
import 'package:hoshan/data/model/ai/ai_response_model.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {
  final String response;

  const SendMessageLoading(this.response);

  @override
  List<Object> get props => [response];
}

class SendMessageSuccess extends SendMessageState {
  final String response;
  final AiResponseModel model;

  const SendMessageSuccess({required this.response, required this.model});

  @override
  List<Object> get props => [response];
}

class SendMessageError extends SendMessageState {
  final String error;

  const SendMessageError(this.error);

  @override
  List<Object> get props => [error];
}
