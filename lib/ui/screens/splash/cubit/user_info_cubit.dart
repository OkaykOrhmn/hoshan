import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/auth/user_info_model.dart';
import 'package:hoshan/data/repository/auth_repository.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoInitial());
  static UserInfoModel userInfoModel = UserInfoModel();

  Future<void> getUserInfo() async {
    emit(UserInfoLoading());
    try {
      final response = await AuthRepository.getUserInfo();
      userInfoModel = response;
      emit(UserInfoSuccess());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        emit(UserInfoConnectionError());
      } else {
        emit(UserInfoFail());
      }
      if (kDebugMode) {
        print("Dio Error is : $e");
      }
    }
  }

  void changeUser(UserInfoModel newUserInfoModel) {
    userInfoModel = newUserInfoModel;
    emit(UserInfoSuccess());
  }
}
