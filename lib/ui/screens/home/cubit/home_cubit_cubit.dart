import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/ai/bots_model.dart';
import 'package:hoshan/data/model/ai/messages_model.dart';
import 'package:hoshan/data/repository/chatbot_repository.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<List<Messages>> {
  static ValueNotifier<Bots?> bot = ValueNotifier(null);
  static ValueNotifier<XFile?> selectedFile = ValueNotifier(null);
  static ValueNotifier<int?> chatId = ValueNotifier(null);
  static ValueNotifier<int> indexed = ValueNotifier(0);
  // static List<Messages> messages = [];
  HomeCubit() : super([]);

  Future<List<Messages>> getItems({required int id}) async {
    try {
      final response = await ChatbotRepository.getMessages(id: id);
      final updatedList = List<Messages>.from(response.messages!);
      HomeCubit.bot.value = response.bot;
      HomeCubit.chatId.value = response.id;
      emit(updatedList); // Copy the current state
    } catch (e) {
      HomeCubit.bot.value = null;
      HomeCubit.chatId.value = -3;
      emit([]); // Copy the current state
    }

    return state;
  }

  Future<Messages?> getLatsHumanMessage() async {
    final updatedList = List<Messages>.from(state);
    Messages? messages;
    for (var message in updatedList) {
      if (!(message.fromBot!)) {
        messages = message;
        break;
      }
    }
    emit(updatedList); // Copy the current state
    return messages;
  }

  // Method to add an item
  void addItem(Messages message) {
    final updatedList = List<Messages>.from(state); // Copy the current state
    updatedList.add(message);
    emit(updatedList); // Emit the new state
  }

  // Method to remove an item
  void removeItem(Messages message) async {
    final updatedList = List<Messages>.from(state); // Copy the current state
    if (updatedList.isNotEmpty) {
      ChatbotRepository.deleteMessage(
          chatId: HomeCubit.chatId.value!, messageId: message.id!);
      updatedList.remove(message);
    }
    emit(updatedList); // Emit the new state
  }

  void clearItems() {
    final updatedList = List<Messages>.from(state); // Copy the current state
    if (updatedList.isNotEmpty) {
      updatedList.clear();
    }
    emit(updatedList); // Emit the new state
  }

  Messages changeItem(Messages oldMessage, Messages newMessage) {
    final updatedList = List<Messages>.from(state); // Copy the current state
    if (updatedList.isNotEmpty) {
      final index = updatedList.indexOf(oldMessage);
      updatedList[index] = newMessage;
    }
    emit(updatedList);
    return newMessage; // Emit the new state
  }

  void changeHumanItemId(dynamic newMessageId) {
    final updatedList = List<Messages>.from(state); // Copy the current state
    if (updatedList.isNotEmpty) {
      updatedList[updatedList.length - 2].id = newMessageId;
    }
    emit(updatedList); // Emit the new state
  }
}
