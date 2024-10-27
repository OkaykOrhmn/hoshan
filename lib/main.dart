import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/core/services/firebase/firebase_api.dart';
import 'package:hoshan/data/storage/shared_preferences_helper.dart';
import 'package:hoshan/firebase_options.dart';
import 'package:hoshan/ui/screens/splash/cubit/user_info_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.initial();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await FirebasApi().initialNotifications();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e');
    }
  }

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserInfoCubit>(
        create: (context) => UserInfoCubit(),
      ),
    ],
    child: const MyApp(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoshan',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: Routes.main,
      onGenerateRoute: Routes.routeGenerator,
      theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(100),
              thumbColor:
                  WidgetStateProperty.all(AppColors.primaryColor.defaultShade),
              trackColor: WidgetStateProperty.all(AppColors.black[50])),
          appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.white, backgroundColor: Colors.white),
          scaffoldBackgroundColor: AppColors.gray[200],
          primaryColor: AppColors.primaryColor.defaultShade,
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor.defaultShade),
          popupMenuTheme: const PopupMenuThemeData(
              surfaceTintColor: Colors.transparent, color: Colors.white),
          bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent)),
    );
  }
}
