import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';

part 'chat_row_edit_state.dart';

class ChatRowEditCubit extends Cubit<ChatRowEditState> {
  ChatRowEditCubit() : super(ChatRowEditInitial());

  Future<void> editTitle(
      {required final int id, required final String title}) async {
    emit(ChatRowEditLoading());
    try {
      await ChatbotRepository.editChat(id: id, title: title);

      emit(ChatRowEditSuccess());
    } on DioException catch (e) {
      emit(ChatRowEditFail());
      if (kDebugMode) {
        print("Dio Error is : $e");
      }
    }
  }
}
