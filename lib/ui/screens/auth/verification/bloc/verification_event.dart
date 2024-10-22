part of 'verification_bloc.dart';

@immutable
sealed class VerificationEvent {}

class LoginWithOTP extends VerificationEvent {
  final String number;
  final String otp;

  LoginWithOTP({required this.number, required this.otp});
}
