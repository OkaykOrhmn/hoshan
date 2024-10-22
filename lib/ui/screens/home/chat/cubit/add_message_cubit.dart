import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/bots_model.dart';
import 'package:hoshan/data/model/send_message_model.dart';

part 'add_message_state.dart';

class AddMessageCubit extends Cubit<List<SendMessageModel>> {
  static Bots? bot;
  static int? chatId;
  AddMessageCubit() : super([]);

  // Method to add a new item
  void addItem(SendMessageModel sendMessageModel) {
    final newList = List<SendMessageModel>.from(state)..add(sendMessageModel);
    emit(newList); // Emit the new state
  }

  void clear() {
    emit([]);
  }
}
