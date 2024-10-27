import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/repository/auth_repository.dart';

part 'check_username_state.dart';

class CheckUsernameCubit extends Cubit<CheckUsernameState> {
  CheckUsernameCubit() : super(CheckUsernameInitial());

  void loading() {
    emit(CheckUsernameLoading());
  }

  Future<void> check(String username) async {
    emit(CheckUsernameLoading());
    try {
      final response = await AuthRepository.checkUsernameIsValid(username);
      emit(response ? CheckUsernameSuccess() : CheckUsernameFail());
    } on DioException catch (e) {
      emit(CheckUsernameFail());
      if (kDebugMode) {
        print('Dio Error: $e');
      }
    }
  }
}
