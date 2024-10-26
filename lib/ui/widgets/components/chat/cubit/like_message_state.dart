part of 'like_message_cubit.dart';

sealed class LikeMessageState extends Equatable {
  const LikeMessageState();

  @override
  List<Object> get props => [];
}

final class LikeMessageInitial extends LikeMessageState {}

final class LikeMessageLiked extends LikeMessageState {}

final class LikeMessageDisLiked extends LikeMessageState {}

final class LikeMessageUnLiked extends LikeMessageState {}

final class LikeMessageLoading extends LikeMessageState {}

final class LikeMessageFail extends LikeMessageState {}
