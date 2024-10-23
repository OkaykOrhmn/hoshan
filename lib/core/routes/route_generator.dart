import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/ui/screens/auth/auth_page.dart';
import 'package:hoshan/ui/screens/auth/cubit/auth_screens_cubit.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
import 'package:hoshan/ui/screens/home/home_page.dart';
import 'package:hoshan/ui/screens/home/library/bloc/chats_history_bloc.dart';
import 'package:hoshan/ui/screens/on_boarding/on_boarding_page.dart';
import 'package:hoshan/ui/screens/setting/edit_profile.dart';
import 'package:hoshan/ui/screens/setting/my_account_page.dart';
import 'package:hoshan/ui/screens/setting/setting_page.dart';
import 'package:hoshan/ui/screens/setting/utilization_report_page.dart';
import 'package:hoshan/ui/screens/splash/splash_page.dart';

class Routes {
  static const String main = '/';
  static const String onBoarding = '/on-boarding-page';
  static const String auth = '/auth-page';
  static const String home = '/home-page';
  static const String setting = '/setting-page';
  static const String editProfile = '/edit-profile-page';
  static const String utilizationReport = '/utilization-report-page';
  static const String myAccount = '/my-account-page';

  static Route<dynamic> routeGenerator(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        switch (routeSettings.name.toString()) {
          case main:
            return const SplashPage();
          case onBoarding:
            return const OnBoardingPage();
          case auth:
            return MultiBlocProvider(providers: [
              BlocProvider<AuthScreensCubit>(
                create: (context) => AuthScreensCubit(),
              )
            ], child: const AuthPage());
          case home:
            return MultiBlocProvider(
              providers: [
                BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
                BlocProvider<ChatsHistoryBloc>(
                  create: (context) =>
                      ChatsHistoryBloc()..add(const GetAllChats()),
                ),
              ],
              child: const HomePage(),
            );
          case setting:
            return const SettingPage();

          case editProfile:
            return const EditProfilePage();

          case utilizationReport:
            return const UtilizationReportPage();

          case myAccount:
            return const MyAccountPage();

          default:
            return const SizedBox();
        }
      },
    );
  }
}
