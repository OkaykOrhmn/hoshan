import 'package:equatable/equatable.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {
  final String message;

  const SendMessageLoading(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessageSuccess extends SendMessageState {
  final String message;

  const SendMessageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessageError extends SendMessageState {
  final String error;

  const SendMessageError(this.error);

  @override
  List<Object> get props => [error];
}