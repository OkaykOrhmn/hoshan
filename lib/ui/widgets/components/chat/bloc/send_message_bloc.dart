import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/ai_response_model.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';
import 'send_message_event.dart';
import 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  static ScrollController scrollController = ScrollController();
  static ValueNotifier<bool> onResponse = ValueNotifier(false);

  static Future<void> scrollToEnd({final double? extra}) async {
    await scrollController.animateTo(
      scrollController.position.minScrollExtent + (extra ?? 0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  SendMessageBloc() : super(SendMessageInitial()) {
    on<SendMessageRequest>((event, emit) async {
      emit(const SendMessageLoading(''));
      onResponse.value = true;
      String result = '';
      String? aiMessageId;
      int? chatId;
      String? humanMessageId;
      await scrollToEnd();
      try {
        // Call your streaming message function and yield states accordingly
        await for (String message
            in ChatbotRepository.sendMessage(event.sendMessageModel)) {
          final res = AiResponseModel.fromJson(jsonDecode(message));
          result += res.content ?? '';
          if (res.aiMessageId != null) {
            aiMessageId = res.aiMessageId;
          }
          if (res.chatId != null) {
            chatId = res.chatId;
          }
          if (res.humanMessageId != null) {
            humanMessageId = res.humanMessageId;
          }
          emit(SendMessageLoading(
              result)); // Yield the received message line by line
          await scrollToEnd();
        }
        emit(SendMessageSuccess(
            message: result,
            aiMessageId: aiMessageId,
            chatId: chatId,
            humanMessageId: humanMessageId));
      } on DioException catch (e) {
        if (ChatbotRepository.cancelToken != null &&
            ChatbotRepository.cancelToken!.isCancelled) {
          emit(SendMessageSuccess(message: result));
        } else {
          emit(SendMessageError('Error: $e'));
        }
      }
      onResponse.value = false;
      await Future.delayed(const Duration(milliseconds: 300));
      await scrollToEnd();
    });
    on<SendMessageLocal>((event, emit) async {
      emit(SendMessageSuccess(message: event.sendMessageModel.query!));
    });
  }
}
