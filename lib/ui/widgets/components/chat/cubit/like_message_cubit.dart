import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';

part 'like_message_state.dart';

class LikeMessageCubit extends Cubit<LikeMessageState> {
  LikeMessageCubit() : super(LikeMessageInitial());

  void getLike({
    required bool? like,
  }) {
    if (like == null) {
      emit(LikeMessageUnLiked());
    } else {
      emit(like ? LikeMessageLiked() : LikeMessageDisLiked());
    }
  }

  Future<void> setLike(
      {required bool? like,
      required final int chatId,
      required final String messageId}) async {
    emit(LikeMessageLoading());
    try {
      await ChatbotRepository.likedMessage(
          chatId: chatId, messageId: messageId, like: like);
      if (like == null) {
        emit(LikeMessageUnLiked());
      } else {
        emit(like ? LikeMessageLiked() : LikeMessageDisLiked());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Dio Error: $e");
      }
    }
  }
}
