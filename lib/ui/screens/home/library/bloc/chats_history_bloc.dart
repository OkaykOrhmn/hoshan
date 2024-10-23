import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/utils/date_time.dart';
import 'package:hoshan/data/model/chats_history_model.dart';
import 'package:hoshan/data/model/chats_indates_model.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';

part 'chats_history_event.dart';
part 'chats_history_state.dart';

class ChatsHistoryBloc extends Bloc<ChatsHistoryEvent, ChatsHistoryState> {
  static final List<ChatsIndatesModel> chatsInDates = [];

  ChatsHistoryBloc() : super(ChatsHistoryInitial()) {
    List<ChatsIndatesModel> onOrganizeChats(List<Chats> chats) {
      final List<Chats> todayChats = [];
      final List<Chats> yesterdayChats = [];
      final List<Chats> weekChats = [];
      final List<Chats> otherChats = [];
      for (var chat in chats) {
        final d = DateTimeUtils.convertStringIsoToDate(chat.createdAt!);
        final today = DateTime.now();
        DateTime oneDayAgo = today.subtract(const Duration(days: 1));

        DateTime oneWeekAgo = oneDayAgo.subtract(const Duration(days: 7));
        int date = int.parse('${d.day}${d.month}${d.year}');
        int todayDate = int.parse('${today.day}${today.month}${today.year}');
        int yesterdayDate =
            int.parse('${oneDayAgo.day}${oneDayAgo.month}${oneDayAgo.year}');
        int weekBeforDate =
            int.parse('${oneWeekAgo.day}${oneWeekAgo.month}${oneWeekAgo.year}');
        if (date == todayDate) {
          todayChats.add(chat);
        } else if (date == yesterdayDate) {
          yesterdayChats.add(chat);
        } else if (todayDate > date && date >= weekBeforDate) {
          weekChats.add(chat);
        } else {
          otherChats.add(chat);
        }
      }

      final List<ChatsIndatesModel> chatsInDates = [
        ChatsIndatesModel(title: 'امروز', chats: todayChats),
        ChatsIndatesModel(title: 'دیروز', chats: yesterdayChats),
        ChatsIndatesModel(title: '‌هفته گذشته', chats: weekChats),
        ChatsIndatesModel(title: 'ماه های اخیر', chats: otherChats),
      ];

      ChatsHistoryBloc.chatsInDates.addAll(chatsInDates);

      return chatsInDates;
    }

    on<ChatsHistoryEvent>((event, emit) async {
      if (event is GetAllChats) {
        emit(ChatsHistoryLoading());
        try {
          final response = await ChatbotRepository.getChats(
              search: event.search, date: event.date);
          if (response.chats == null || response.chats!.isEmpty) {
            emit(ChatsHistoryEmpty());
          } else {
            emit(ChatsHistorySuccess(
                chatsInDates: onOrganizeChats(response.chats!)));
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
            onOrganizeChats(response.chats!);
            emit(ChatsHistorySuccess(
                chatsInDates: onOrganizeChats(response.chats!)));
          }
        } on DioException catch (e) {
          emit(ChatsHistoryFail());
          if (kDebugMode) {
            print("Dio Error is : $e");
          }
        }
      }

      if (event is AddChat) {
        chatsInDates.first.chats.add(event.chats);
        emit(ChatsHistoryLoading());

        emit(ChatsHistorySuccess(chatsInDates: chatsInDates));
      }

      if (event is RemoveChat) {
        try {
          await ChatbotRepository.deleteChat(id: event.chats.id!);
          int? index;
          int? mainIndex;
          for (var chatInDate in chatsInDates) {
            for (var chat in chatInDate.chats) {
              if (chat == event.chats) {
                index = chatInDate.chats.indexOf(chat);
                mainIndex = chatsInDates.indexOf(chatInDate);
              }
            }
          }
          if (mainIndex != null && index != null) {
            chatsInDates[mainIndex].chats.removeAt(index);
          }
          if (HomeCubit.chatId.value == event.chats.id) {
            HomeCubit.chatId.value = null;
          }
          emit(ChatsHistoryLoading());
          emit(ChatsHistorySuccess(chatsInDates: chatsInDates));
        } on DioException catch (e) {
          // emit(ChatsHistoryFail());
          if (kDebugMode) {
            print("Dio Error is : $e");
          }
        }
      }
    });
  }
}
