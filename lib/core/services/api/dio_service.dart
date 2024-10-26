import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hoshan/data/storage/shared_preferences_helper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static String baseURL = 'https://hoshan-api.liara.run';
  static String baseURL2 = 'https://api.didvan.app/ai';
  //user
  static String sendOTP = '/user/otp'; //POST
  static String register = '/user/register'; //POST
  static String loginWithPassword = '/user/login'; //POST
  static String loginWithOTP = '/user/login/otp'; //POST
  static String getInfo = '/user/info'; //GET
  //chatbot
  static String sendMessage = '/chatbot/'; //POST //GET //DELETE //STREAM
  static String chatHistory({required final int id}) =>
      '/chatbot/$id'; //GET //DELETE q{id}
  static String editTitle({required final int id}) =>
      '/chatbot/$id/title'; //PUT
  static String archive({required final int id}) =>
      '/chatbot/$id/archive'; //PUT
  static String relatedQuestions({required final int id}) =>
      '/chatbot/$id/related_questions'; //POST q{id};
  static String messageDelete(
          {required final int id, required final String messageId}) =>
      '/chatbot/$id/message/$messageId'; //DELETE q{id} q{message_id}
  static String likeMessage(
          {required final int id, required final String messageId}) =>
      '/chatbot/$id/message/$messageId/feedback'; //PUT q{id} q{message_id}
  //bot
  static String getAllBots = '/bot/'; //GET q{string:serach}

  static final token = AuthTokenStorage.getToken();
  DioService() {
    if (kDebugMode) {
      print("AuthToken: $token");
    }
  }
  static final Dio _dio = Dio(BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(milliseconds: 30000),
      responseType: ResponseType.json,
      headers: {
        "Content-Type": "application/json",
        'accept': '*/*',
        'Authorization': "Bearer $token",
      }))
    ..interceptors.add(PrettyDioLogger());

  static final Dio _dioStream = Dio(BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(milliseconds: 30000),
      responseType: ResponseType.stream,
      headers: {
        "Content-Type": "application/json",
        'accept': '*/*',
        'Authorization': "Bearer $token",
        //        'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzQ2LCJyb2xlSWQiOjEsImFwcElkIjowLCJpYXQiOjE3MjU3ODAyNjF9.wuYHQOF6rQ96-5mvVR5OEqJ-E2QL7XpXzXD3JwjtHH4",
      }))
    ..interceptors.add(PrettyDioLogger());

  Dio get sendRequest => _dio;
  Dio get sendRequestStream => _dioStream;
}
