import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/auth/auth_screens_enum.dart';

class AuthScreensCubit extends Cubit<AuthScreens> {
  AuthScreensCubit() : super(AuthScreens.mobile);

  String username = '';
  String password = '';
  String otp = '';
  bool inRegister = true;

  void changeState(AuthScreens authScreens) {
    emit(authScreens);
  }
}
