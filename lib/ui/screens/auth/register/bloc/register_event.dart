part of 'register_bloc.dart';

sealed class RegisterEvent {}

class RegisterUser extends RegisterEvent {
  final String phoneNumber;

  RegisterUser({required this.phoneNumber});
}

class LoginUser extends RegisterEvent {
  final String phoneNumber;

  LoginUser({required this.phoneNumber});
}
