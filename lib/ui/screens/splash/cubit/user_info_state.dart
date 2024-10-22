part of 'user_info_cubit.dart';

@immutable
sealed class UserInfoState {}

final class UserInfoInitial extends UserInfoState {}

final class UserInfoLoading extends UserInfoState {}

final class UserInfoSuccess extends UserInfoState {}

final class UserInfoFail extends UserInfoState {}

final class UserInfoConnectionError extends UserInfoState {}
