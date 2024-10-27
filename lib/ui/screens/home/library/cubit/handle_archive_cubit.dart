import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';

part 'handle_archive_state.dart';

class HandleArchiveCubit extends Cubit<HandleArchiveState> {
  HandleArchiveCubit() : super(HandleArchiveInitial());

  Future<void> addToArchive(final int id) async {
    emit(HandleArchiveLoading());
    try {
      await ChatbotRepository.archiveChat(id, true);

      emit(HandleArchiveSuccess());
    } on DioException catch (e) {
      emit(HandleArchiveFail());
      if (kDebugMode) {
        print("Dio Error is : $e");
      }
    }
  }

  Future<void> removeFromArchive(final int id) async {
    emit(HandleArchiveLoading());
    try {
      await ChatbotRepository.archiveChat(id, false);

      emit(HandleArchiveSuccess());
    } on DioException catch (e) {
      emit(HandleArchiveFail());
      if (kDebugMode) {
        print("Dio Error is : $e");
      }
    }
  }
}
