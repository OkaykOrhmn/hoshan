part of 'related_questions_bloc.dart';

sealed class RelatedQuestionsEvent extends Equatable {
  const RelatedQuestionsEvent();

  @override
  List<Object> get props => [];
}

class GetAllRelatedQuestions extends RelatedQuestionsEvent {
  final int chatId;
  final String messageId;
  final String content;

  const GetAllRelatedQuestions(
      {required this.chatId, required this.messageId, required this.content});
}

class ClearAllRelatedQuestions extends RelatedQuestionsEvent {}
