part of 'chat_row_edit_cubit.dart';

sealed class ChatRowEditState extends Equatable {
  const ChatRowEditState();

  @override
  List<Object> get props => [];
}

final class ChatRowEditInitial extends ChatRowEditState {}

final class ChatRowEditLoading extends ChatRowEditState {}

final class ChatRowEditSuccess extends ChatRowEditState {}

final class ChatRowEditFail extends ChatRowEditState {}
