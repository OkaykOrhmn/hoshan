part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginWithPassword extends LoginEvent {
  final String username;
  final String password;

  LoginWithPassword({required this.username, required this.password});
}
