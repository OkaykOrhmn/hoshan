part of 'chats_history_bloc.dart';

sealed class ChatsHistoryEvent extends Equatable {
  const ChatsHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetAllChats extends ChatsHistoryEvent {
  final String? search;
  final String? date;
  final bool archive;

  const GetAllChats({this.search, this.date, this.archive = false});
}

class AddChat extends ChatsHistoryEvent {
  final Chats chats;

  const AddChat({required this.chats});
}

class RemoveChat extends ChatsHistoryEvent {
  final Chats chats;
  final bool withCall;

  const RemoveChat({required this.chats, this.withCall = true});
}

class RemoveAll extends ChatsHistoryEvent {}
