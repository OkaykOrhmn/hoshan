import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/repository/auth_repository.dart';
import 'package:hoshan/data/storage/shared_preferences_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginWithPassword) {
        emit(LoginLoading());
        try {
          final response = await AuthRepository.loginWithPassword(
              event.username, event.password);
          AuthTokenStorage.setToken(response.accessToken.toString());
          emit(LoginSuccess());
        } on DioException catch (e) {
          emit(LoginFail(
              isPasswordIncorrect:
                  e.response?.data['detail'] != 'User not found'));
          if (kDebugMode) {
            print('Dio Error is $e');
          }
        }
      }
    });
  }
}
