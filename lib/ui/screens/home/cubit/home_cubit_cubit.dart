import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/bots_model.dart';
import 'package:hoshan/data/model/messages_model.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  static Bots? bot;
  static ValueNotifier<int?> chatId = ValueNotifier(null);
  static ValueNotifier<int> indexed = ValueNotifier(0);
  static List<Messages> messages = [];
  HomeCubit() : super(HomeCubitInitial());
}
