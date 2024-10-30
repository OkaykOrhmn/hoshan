import 'dart:convert';

import 'package:cross_file/cross_file.dart';
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
      if (sendMessageModel.file != null) {
        MultipartFile multipartFile = await MultipartFile.fromFile(
            sendMessageModel.file!.path,
            filename: sendMessageModel.file!.name);
        formDatBody.files.add(MapEntry('image', multipartFile));
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

  static Future<XFile?> createXFileFromUrl(String url) async {
    try {
      final response = await _dioService.sendRequest.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        // Create an XFile from the bytes
        Uint8List bytes = response.data; // Get the bytes from the response
        return XFile.fromData(bytes,
            name:
                'file_${DateTime.now().millisecondsSinceEpoch}.txt'); // Customize the name and extension as needed
      } else {
        throw Exception('Failed to load file from URL');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching file: $e');
      }
      return null; // Return null in case of an error
    }
  }
}
