part of 'all_bots_cubit.dart';

sealed class AllBotsState extends Equatable {
  const AllBotsState();

  @override
  List<Object> get props => [];
}

final class AllBotsInitial extends AllBotsState {}

final class AllBotsLoading extends AllBotsState {}

final class AllBotsSuccess extends AllBotsState {
  final List<Bots> bots;

  const AllBotsSuccess({required this.bots});
}

final class AllBotsFail extends AllBotsState {}

final class AllBotsEmpty extends AllBotsState {}
