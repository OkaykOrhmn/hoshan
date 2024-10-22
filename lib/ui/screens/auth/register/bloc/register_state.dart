part of 'register_bloc.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterSuccess extends RegisterState {}

final class RegisterFail extends RegisterState {
  final String error;

  RegisterFail({required this.error});
}

final class RegisterLoading extends RegisterState {}
