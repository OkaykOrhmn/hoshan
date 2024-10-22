// ignore_for_file: deprecated_member_use_from_same_package, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/services/firebase/auth_service.dart';
import 'package:hoshan/data/model/auth_screens_enum.dart';
import 'package:hoshan/ui/screens/auth/cubit/auth_screens_cubit.dart';
import 'package:hoshan/ui/screens/auth/login/bloc/login_bloc.dart';
import 'package:hoshan/ui/screens/auth/login/login_screen.dart';
import 'package:hoshan/ui/screens/auth/register/bloc/register_bloc.dart';
import 'package:hoshan/ui/screens/auth/register/register_screen.dart';
import 'package:hoshan/ui/screens/auth/verification/bloc/verification_bloc.dart';
import 'package:hoshan/ui/screens/auth/verification/verification_screen.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return context.read<AuthScreensCubit>().state ==
                AuthScreens.verification
            ? false
            : true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                header(),
                ToggleSwitch(
                  cornerRadius: 100.0,
                  activeBgColors: [
                    [AppColors.primaryColor.defaultShade],
                    [AppColors.primaryColor.defaultShade]
                  ],
                  customTextStyles: [AppTextStyles.body3],
                  customWidths: const [90, 90],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Theme.of(context).scaffoldBackgroundColor,
                  inactiveFgColor: AppColors.primaryColor.defaultShade,
                  borderColor: [AppColors.primaryColor.defaultShade],
                  totalSwitches: 2,
                  labels: const ['ثبت نام', 'ورود'],
                  icons: const [null, null],
                  onToggle: (index) {
                    if (index == 0) {
                      context.read<AuthScreensCubit>().inRegister = true;
                      context
                          .read<AuthScreensCubit>()
                          .changeState(AuthScreens.mobile);
                    } else {
                      context.read<AuthScreensCubit>().inRegister = false;
                      context
                          .read<AuthScreensCubit>()
                          .changeState(AuthScreens.usernameAndPassword);
                    }
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                BlocBuilder<AuthScreensCubit, AuthScreens>(
                  builder: (context, state) {
                    Widget mainScreen;
                    if (state == AuthScreens.mobile) {
                      mainScreen = const RegisterScreen();
                    } else if (state == AuthScreens.usernameAndPassword) {
                      mainScreen = const LoginScreen();
                    } else {
                      mainScreen = const VerificationScreen();
                    }
                    return Column(
                      children: [
                        MultiBlocProvider(
                          providers: [
                            BlocProvider<RegisterBloc>(
                              create: (context) => RegisterBloc(),
                            ),
                            BlocProvider<LoginBloc>(
                              create: (context) => LoginBloc(),
                            ),
                            BlocProvider<VerificationBloc>(
                              create: (context) => VerificationBloc(),
                            ),
                          ],
                          child: mainScreen,
                        ),
                        if (state != AuthScreens.verification)
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'یا',
                                  style: AppTextStyles.body3,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: 48,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: AppColors
                                                    .primaryColor.defaultShade,
                                                width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                      onPressed: () async {
                                        try {
                                          await AuthService()
                                              .signInWithGoogle();
                                        } on PlatformException catch (e) {
                                          if (e.code == 'sign_in_failed') {
                                            throw Exception(
                                                'Google Sign In failed. Please check your Google account and try again.');
                                          } else {
                                            throw Exception(
                                                'An error occurred while signing in with Google: ${e.message}');
                                          }
                                        } catch (e) {
                                          throw Exception(
                                              'An error occurred while signing in with Google: ${e.toString()}');
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'ورود با حساب گوگل',
                                            style: AppTextStyles.body4.copyWith(
                                                color: AppColors
                                                    .primaryColor.defaultShade),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Assets.icon.signin.igoogle.svg(),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          )
                      ],
                    );
                  },
                )
              ],
            ),
            footer()
          ],
        ),
      ),
    );
  }

  Center header() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.image.appIcon
                .svg(color: AppColors.primaryColor.defaultShade),
            const SizedBox(
              height: 12,
            ),
            Text("هـوشان",
                style: AppTextStyles.headline1.copyWith(
                  color: AppColors.primaryColor.defaultShade,
                ))
          ],
        ),
      ),
    );
  }

  Padding footer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: '،با ثبت نام و ورود به اپلیکیشن هوشان\n',
              style: AppTextStyles.body4.copyWith(color: AppColors.gray[900]),
              children: [
                TextSpan(
                    text: '.شرایط',
                    style: AppTextStyles.body4.copyWith(
                      color: AppColors.primaryColor.defaultShade,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                const TextSpan(text: ' و '),
                TextSpan(
                    text: 'قوانین حریم خصوصی ',
                    style: AppTextStyles.body4.copyWith(
                      color: AppColors.primaryColor.defaultShade,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                const TextSpan(text: 'را می‌پذیرم')
              ])),
    );
  }
}
