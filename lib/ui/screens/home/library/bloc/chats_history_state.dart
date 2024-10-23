part of 'chats_history_bloc.dart';

sealed class ChatsHistoryState extends Equatable {
  const ChatsHistoryState();

  @override
  List<Object> get props => [];
}

final class ChatsHistoryInitial extends ChatsHistoryState {}

final class ChatsHistoryLoading extends ChatsHistoryState {}

final class ChatsHistorySuccess extends ChatsHistoryState {
  final List<ChatsIndatesModel> chatsInDates;

  const ChatsHistorySuccess({required this.chatsInDates});
}

final class ChatsHistoryFail extends ChatsHistoryState {}

final class ChatsHistoryEmpty extends ChatsHistoryState {}
