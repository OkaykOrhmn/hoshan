part of 'check_username_cubit.dart';

sealed class CheckUsernameState extends Equatable {
  const CheckUsernameState();

  @override
  List<Object> get props => [];
}

final class CheckUsernameInitial extends CheckUsernameState {}

final class CheckUsernameSuccess extends CheckUsernameState {}

final class CheckUsernameFail extends CheckUsernameState {}

final class CheckUsernameLoading extends CheckUsernameState {}
