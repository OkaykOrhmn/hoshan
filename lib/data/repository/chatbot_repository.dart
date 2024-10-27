import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hoshan/core/services/api/dio_service.dart';
import 'package:hoshan/data/model/ai/chats_history_model.dart';
import 'package:hoshan/data/model/ai/messages_model.dart';
import 'package:hoshan/data/model/ai/related_questions_model.dart';
import 'package:hoshan/data/model/ai/send_message_model.dart';

class ChatbotRepository {
  static final DioService _dioService = DioService();
  static CancelToken? cancelToken;

  static void cancelSendMessage() {
    cancelToken?.cancel();
  }

  static Stream<String> sendMessage(SendMessageModel sendMessageModel) async* {
    cancelToken = CancelToken();

    try {
      FormData formDatBody = FormData();
      formDatBody.fields
          .add(MapEntry('model', sendMessageModel.model.toString()));
      formDatBody.fields
          .add(MapEntry('query', sendMessageModel.query.toString()));
      formDatBody.fields
          .add(MapEntry('bot_id', sendMessageModel.botId.toString()));
      formDatBody.fields.add(MapEntry(
          'retry', (sendMessageModel.retry ?? false).toString().toLowerCase()));
      if (sendMessageModel.id != null) {
        formDatBody.fields.add(MapEntry("id", sendMessageModel.id.toString()));
      }

      Response<ResponseBody> response =
          await _dioService.sendRequestStream.post<ResponseBody>(
        DioService.sendMessage,
        data: formDatBody,
        cancelToken: cancelToken,
      );
      await for (var value in response.data!.stream) {
        if (kDebugMode) {
          print(utf8.decode(value));
        }
        yield utf8
            .decode(value)
            .replaceAll('}{', ' } \n { ')
            .replaceAll('}', ' } ')
            .replaceAll('{', ' { ');
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

  static Future<MessagesModel> getMessages({required final int id}) async {
    try {
      Response response = await _dioService.sendRequest.get(
        DioService.chatHistory(id: id),
      );
      return MessagesModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

  static Future<Response> editChat(
      {required final int id, required final String title}) async {
    try {
      final response = await _dioService.sendRequest
          .put(DioService.editTitle(id: id), data: {"title": title});
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<Response> deleteChat({required final int id}) async {
    try {
      final response =
          await _dioService.sendRequest.delete(DioService.chatHistory(id: id));
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<Response> deleteAllChats() async {
    try {
      final response =
          await _dioService.sendRequest.delete(DioService.sendMessage);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<Response> likedMessage(
      {required final int chatId,
      required final String messageId,
      required final bool? like}) async {
    try {
      final response = await _dioService.sendRequest.put(
          DioService.likeMessage(id: chatId, messageId: messageId),
          data: {"like": like});
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<Response> deleteMessage(
      {required final int chatId, required final String messageId}) async {
    try {
      final response = await _dioService.sendRequest.delete(
        DioService.messageDelete(id: chatId, messageId: messageId),
      );
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<RelatedQuestionsModel> getRelatedQuestions(
      {required final int chatId,
      required final String messageId,
      required final String content}) async {
    try {
      final response = await _dioService.sendRequest.post(
          DioService.relatedQuestions(
            id: chatId,
          ),
          data: {"id": messageId, "content": content});
      return RelatedQuestionsModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

  static Future<bool> archiveChat(final int chatId, final bool archive) async {
    try {
      final response = await _dioService.sendRequest.put(
          DioService.archive(
            id: chatId,
          ),
          data: {"archive": archive});
      return (response.statusCode!) >= 200 && (response.statusCode!) < 300;
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
