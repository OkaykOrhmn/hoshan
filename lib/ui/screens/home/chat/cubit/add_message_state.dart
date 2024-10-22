part of 'add_message_cubit.dart';

sealed class AddMessageState extends Equatable {
  final List<SendMessageModel> items;
  const AddMessageState({required this.items});
  @override
  List<Object> get props => [];
}
