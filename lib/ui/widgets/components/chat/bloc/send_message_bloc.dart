import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/ai/ai_response_model.dart';
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
      AiResponseModel aiResponseModel = AiResponseModel();
      await scrollToEnd();
      try {
        // Call your streaming message function and yield states accordingly
        await for (String message
            in ChatbotRepository.sendMessage(event.request)) {
          Map<String, dynamic> jsonMap;
          try {
            jsonMap = jsonDecode(message);
          } catch (e) {
            jsonMap = {};
          }

          final res = AiResponseModel.fromJson(jsonMap);
          result += res.content ?? ''; // Add each content to the list
          aiResponseModel = aiResponseModel.copyWith(
              aiMessageId: res.aiMessageId,
              chatId: res.chatId,
              chatTitle: res.chatTitle,
              content: res.content,
              humanMessageId: res.humanMessageId);
          emit(SendMessageLoading(
              result)); // Yield the received message line by line
          await scrollToEnd();
        }
        emit(SendMessageSuccess(response: result, model: aiResponseModel));
      } on DioException catch (e) {
        emit(SendMessageError('Error: $e'));
      }
      onResponse.value = false;
      await Future.delayed(const Duration(milliseconds: 300));
      await scrollToEnd();
    });
  }
}
