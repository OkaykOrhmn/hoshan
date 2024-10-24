import 'package:dio/dio.dart';
import 'package:hoshan/core/services/api/dio_service.dart';
import 'package:hoshan/data/model/auth/login_model.dart';
import 'package:hoshan/data/model/auth/user_info_model.dart';

class AuthRepository {
  static final DioService _dioService = DioService();

  static Future<UserInfoModel> getUserInfo() async {
    try {
      Response response = await _dioService.sendRequest.get(DioService.getInfo);
      return UserInfoModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

  static Future<Response> registerUser(String number) async {
    try {
      Response response = await _dioService.sendRequest
          .post(DioService.register, data: {'mobile_number': number});
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<Response> sendOtp(String number) async {
    try {
      Response response = await _dioService.sendRequest
          .post(DioService.sendOTP, data: {'mobile_number': number});
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<LoginModel> loginWithPassword(
      String number, String password) async {
    try {
      Response response = await _dioService.sendRequest.post(
          DioService.loginWithPassword,
          data: {'username': number, 'password': password});
      return LoginModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

  static Future<LoginModel> loginWithOTP(String number, String otp) async {
    try {
      Response response = await _dioService.sendRequest.post(
          DioService.loginWithOTP,
          data: {"mobile_number": number, "otp": otp});
      return LoginModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }
}
