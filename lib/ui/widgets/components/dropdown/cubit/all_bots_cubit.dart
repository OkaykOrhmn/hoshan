import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/ai/bots_model.dart';
import 'package:hoshan/data/repository/bot_repository.dart';

part 'all_bots_state.dart';

class AllBotsCubit extends Cubit<AllBotsState> {
  AllBotsCubit() : super(AllBotsInitial());

  Future<void> getAllBots() async {
    emit(AllBotsLoading());
    try {
      final response = await BotRepository.getBots();
      if (response.bots == null || response.bots!.isEmpty) {
        emit(AllBotsEmpty());
      } else {
        emit(AllBotsSuccess(bots: response.bots!));
      }
    } on DioException catch (e) {
      emit(AllBotsFail());
      if (kDebugMode) {
        print("Dio Error is : $e");
      }
    }
  }
}
