part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFail extends LoginState {
  final bool isPasswordIncorrect;

  LoginFail({required this.isPasswordIncorrect});
}

final class LoginLoading extends LoginState {}
