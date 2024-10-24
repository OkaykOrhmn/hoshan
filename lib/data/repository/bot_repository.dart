import 'package:dio/dio.dart';
import 'package:hoshan/core/services/api/dio_service.dart';
import 'package:hoshan/data/model/ai/bots_model.dart';

class BotRepository {
  static final DioService _dioService = DioService();

  static Future<BotsModel> getBots({final String? search}) async {
    try {
      Map<String, dynamic>? queryParameters = {};
      if (search != null) {
        queryParameters['query'] = search;
      }
      Response response = await _dioService.sendRequest
          .get(DioService.getAllBots, queryParameters: queryParameters);
      return BotsModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }
}
