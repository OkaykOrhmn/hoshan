import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hoshan/core/services/api/dio_service.dart';
import 'package:hoshan/data/model/chats_history_model.dart';
import 'package:hoshan/data/model/send_message_model.dart';

class ChatbotRepository {
  static final DioService _dioService = DioService();
  static CancelToken? cancelToken;

  static void cancelSendMessage() {
    cancelToken?.cancel();
  }

  static Stream<String> sendMessage(SendMessageModel sendMessageModel) async* {
    cancelToken = CancelToken();

    try {
      Response<ResponseBody> response =
          await _dioService.sendRequestStream.post<ResponseBody>(
        DioService.sendMessage,
        data: sendMessageModel.toJson(),
        cancelToken: cancelToken,
      );

      await for (var value in response.data!.stream) {
        if (kDebugMode) {
          print(utf8.decode(value));
        }
        yield utf8.decode(value);
      }
    } catch (e) {
      yield '';
    }
  }

  static Future<ChatsHistoryModel> getChats(
      {final bool archive = false,
      final String? search,
      final String? date}) async {
    try {
      Map<String, dynamic> queryParameters = {
        'archive': archive.toString().toLowerCase()
      };
      if (search != null) {
        queryParameters.addAll({'query': search});
      }

      if (date != null) {
        queryParameters.addAll({'date': date});
      }

      Response response = await _dioService.sendRequest
          .get(DioService.sendMessage, queryParameters: queryParameters);
      return ChatsHistoryModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

  /*
 static Stream<String> sendMessage(SendMessageModel sendMessageModel) async* {
    try {
      Response<ResponseBody> response =
          await _dioService.sendRequestStream.post<ResponseBody>(
        '/2/gpt-4o',
        data: true
            ? {'prompt': "tell me a story"}
            : SendMessageModel(
                    model: "gpt-4o-mini", query: "Hello", botId: 1, id: 1)
                .toJson(),
      );

      await for (var value in response.data!.stream) {
        if (kDebugMode) {
          print(utf8.decode(value));
        }
        yield utf8.decode(value);
      }
    } catch (e) {
      yield 'Error: $e';
    }
  }
  */

  /*
StreamBuilder<String>(
            stream: ChatbotRepository.sendMessage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
              ***do your view***
              }
  */
}
