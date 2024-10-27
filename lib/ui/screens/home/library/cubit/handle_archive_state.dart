part of 'handle_archive_cubit.dart';

sealed class HandleArchiveState extends Equatable {
  const HandleArchiveState();

  @override
  List<Object> get props => [];
}

final class HandleArchiveInitial extends HandleArchiveState {}

final class HandleArchiveLoading extends HandleArchiveState {}

final class HandleArchiveSuccess extends HandleArchiveState {}

final class HandleArchiveFail extends HandleArchiveState {}
