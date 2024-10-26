import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/ai/related_questions_model.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';

part 'related_questions_event.dart';
part 'related_questions_state.dart';

class RelatedQuestionsBloc
    extends Bloc<RelatedQuestionsEvent, RelatedQuestionsState> {
  RelatedQuestionsBloc() : super(RelatedQuestionsInitial()) {
    on<RelatedQuestionsEvent>((event, emit) async {
      if (event is GetAllRelatedQuestions) {
        emit(RelatedQuestionsLoading());
        try {
          final response = await ChatbotRepository.getRelatedQuestions(
              chatId: event.chatId,
              messageId: event.messageId,
              content: event.content);
          emit(RelatedQuestionsSuccess(relatedQuestionsModel: response));
        } catch (e) {
          emit(RelatedQuestionsFail());
          if (kDebugMode) {
            print("Dio Error: $e");
          }
        }
      }
      if (event is ClearAllRelatedQuestions) {
        emit(RelatedQuestionsFail());
      }
    });
  }
}
