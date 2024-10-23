part of 'chats_history_bloc.dart';

sealed class ChatsHistoryEvent extends Equatable {
  const ChatsHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetAllChats extends ChatsHistoryEvent {
  final String? search;
  final String? date;

  const GetAllChats({this.search, this.date});
}

class GetArchivedChats extends ChatsHistoryEvent {
  final String? search;
  final String? date;

  const GetArchivedChats({this.search, this.date});
}

class AddChat extends ChatsHistoryEvent {
  final Chats chats;

  const AddChat({required this.chats});
}

class RemoveChat extends ChatsHistoryEvent {
  final Chats chats;

  const RemoveChat({required this.chats});
}
