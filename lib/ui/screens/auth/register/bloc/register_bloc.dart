import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      if (event is RegisterUser) {
        emit(RegisterLoading());
        try {
          await AuthRepository.registerUser(event.phoneNumber);

          emit(RegisterSuccess());
        } on DioException catch (e) {
          emit(RegisterFail(error: e.response!.data['detail']));
          if (kDebugMode) {
            print("Dio Error is : $e");
          }
        }
      }

      if (event is LoginUser) {
        emit(RegisterLoading());
        try {
          await AuthRepository.sendOtp(event.phoneNumber);

          emit(RegisterSuccess());
        } on DioException catch (e) {
          emit(RegisterFail(error: e.response!.data['detail']));
          if (kDebugMode) {
            print("Dio Error is : $e");
          }
        }
      }
    });
  }
}
