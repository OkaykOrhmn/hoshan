import 'package:cross_file/cross_file.dart';
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

  static Future<bool> checkUsernameIsValid(String username) async {
    try {
      Response response = await _dioService.sendRequest
          .post(DioService.checkUsername, data: {"username": username});
      return response.data['available'];
    } catch (ex) {
      rethrow;
    }
  }

  static Future<bool> editUsername(String username) async {
    try {
      Response response = await _dioService.sendRequest
          .put(DioService.editUsername, data: {"username": username});
      return (response.statusCode!) >= 200 && (response.statusCode!) < 300;
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> editImageProfile(XFile image) async {
    try {
      FormData formData = FormData();
      MultipartFile multipartFile =
          await MultipartFile.fromFile(image.path, filename: image.name);

      formData.files.add(MapEntry('file', multipartFile));
      Response response = await _dioService.sendRequest
          .put(DioService.editProfile, data: formData);
      return (response.statusCode!) >= 200 && (response.statusCode!) < 300;
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> editPasswordProfile(String password) async {
    try {
      Response response = await _dioService.sendRequest
          .put(DioService.editPassword, data: {"password": password});
      return (response.statusCode!) >= 200 && (response.statusCode!) < 300;
    } catch (ex) {
      return false;
    }
  }
}
