import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/repository/auth_repository.dart';
import 'package:hoshan/data/storage/shared_preferences_helper.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial()) {
    on<VerificationEvent>((event, emit) async {
      if (event is LoginWithOTP) {
        emit(VerificationLoading());
        try {
          final response =
              await AuthRepository.loginWithOTP(event.number, event.otp);
          AuthTokenStorage.setToken(response.accessToken.toString());
          emit(VerificationSuccess());
        } on DioException catch (e) {
          emit(VerificationFail());
          if (kDebugMode) {
            print("Dio Error is : $e");
          }
        }
      }
    });
  }
}
