part of 'related_questions_bloc.dart';

sealed class RelatedQuestionsState extends Equatable {
  const RelatedQuestionsState();

  @override
  List<Object> get props => [];
}

final class RelatedQuestionsInitial extends RelatedQuestionsState {}

final class RelatedQuestionsLoading extends RelatedQuestionsState {}

final class RelatedQuestionsSuccess extends RelatedQuestionsState {
  final RelatedQuestionsModel relatedQuestionsModel;

  const RelatedQuestionsSuccess({required this.relatedQuestionsModel});
}

final class RelatedQuestionsFail extends RelatedQuestionsState {}
