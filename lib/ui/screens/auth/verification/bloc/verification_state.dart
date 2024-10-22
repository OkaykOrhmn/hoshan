part of 'verification_bloc.dart';

@immutable
sealed class VerificationState {}

final class VerificationInitial extends VerificationState {}

final class VerificationSuccess extends VerificationState {}

final class VerificationFail extends VerificationState {}

final class VerificationLoading extends VerificationState {}
