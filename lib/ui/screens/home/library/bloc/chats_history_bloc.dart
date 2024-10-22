import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/chats_history_model.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';

part 'chats_history_event.dart';
part 'chats_history_state.dart';

class ChatsHistoryBloc extends Bloc<ChatsHistoryEvent, ChatsHistoryState> {
  ChatsHistoryBloc() : super(ChatsHistoryInitial()) {
    on<ChatsHistoryEvent>((event, emit) async {
      if (event is GetAllChats) {
        emit(ChatsHistoryLoading());
        try {
          final response = await ChatbotRepository.getChats(
              search: event.search, date: event.date);
          if (response.chats == null || response.chats!.isEmpty) {
            emit(ChatsHistoryEmpty());
          } else {
            emit(ChatsHistorySuccess(chats: response.chats!));
          }
        } on DioException catch (e) {
          emit(ChatsHistoryFail());
          if (kDebugMode) {
            print("Dio Error is : $e");
          }
        }
      }
      if (event is GetArchivedChats) {
        emit(ChatsHistoryLoading());
        try {
          final response = await ChatbotRepository.getChats(
              archive: true, search: event.search, date: event.date);
          if (response.chats == null || response.chats!.isEmpty) {
            emit(ChatsHistoryEmpty());
          } else {
            emit(ChatsHistorySuccess(chats: response.chats!));
          }
        } on DioException catch (e) {
          emit(ChatsHistoryFail());
          if (kDebugMode) {
            print("Dio Error is : $e");
          }
        }
      }
    });
  }
}
