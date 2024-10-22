import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/core/utils/date_time.dart';
import 'package:hoshan/data/model/auth_screens_enum.dart';
import 'package:hoshan/ui/screens/auth/cubit/auth_screens_cubit.dart';
import 'package:hoshan/ui/screens/auth/register/bloc/register_bloc.dart';
import 'package:hoshan/ui/screens/auth/verification/bloc/verification_bloc.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  ValueNotifier<bool> error = ValueNotifier(false);
  ValueNotifier<bool> readOnly = ValueNotifier(false);
  ValueNotifier<int> seconds = ValueNotifier(120);
  Timer? _timer;
  final defaultPinTheme = PinTheme(
      textStyle: AppTextStyles.headline5
          .copyWith(color: AppColors.primaryColor.defaultShade),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.gray.defaultShade)));

  final errorPinTheme = PinTheme(
      textStyle:
          AppTextStyles.headline5.copyWith(color: AppColors.red.defaultShade),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.red.defaultShade)));

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      seconds.value = seconds.value - 1;
      if (seconds.value == 0) {
        timer.cancel();
        error.value = true;
        readOnly.value = true;
        return;
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationBloc, VerificationState>(
      listener: (context, state) {
        if (state is VerificationLoading) {
          readOnly.value = true;
        } else {
          readOnly.value = false;
        }
        if (state is VerificationFail) {
          error.value = true;
        } else if (state is VerificationSuccess) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
            valueListenable: readOnly,
            builder: (context, readOnlyVal, _) {
              return Column(
                children: [
                  Text(
                    '.کد تایید شش رقمی به شماره ${context.read<AuthScreensCubit>().username} ارسال شد',
                    style: AppTextStyles.body5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => context
                              .read<AuthScreensCubit>()
                              .changeState(AuthScreens.mobile),
                          child: Text(
                            'تغییر شماره همراه',
                            style: AppTextStyles.body5.copyWith(
                                color: AppColors.primaryColor.defaultShade),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: AppColors.primaryColor.defaultShade,
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 16),
                      child: ValueListenableBuilder(
                          valueListenable: error,
                          builder: (context, errVal, _) {
                            return Pinput(
                              readOnly: readOnlyVal,
                              forceErrorState: errVal,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme.copyBorderWith(
                                  border: Border.all(
                                      color:
                                          AppColors.primaryColor.defaultShade)),
                              submittedPinTheme: defaultPinTheme.copyBorderWith(
                                  border: Border.all(
                                      color:
                                          AppColors.primaryColor.defaultShade)),
                              errorPinTheme: errorPinTheme,
                              keyboardType: TextInputType.number,
                              errorText: seconds.value == 0
                                  ? ''
                                  : '!کد وارد شده اشتباه است',
                              errorTextStyle: AppTextStyles.body2
                                  .copyWith(color: AppColors.red.defaultShade),
                              length: 6,
                              autofocus: true,
                              closeKeyboardWhenCompleted: true,
                              onChanged: (value) {
                                error.value = false;
                              },
                              onCompleted: (String value) {
                                final number =
                                    context.read<AuthScreensCubit>().username;
                                context.read<VerificationBloc>().add(
                                    LoginWithOTP(number: number, otp: value));
                              },
                            );
                          })),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 16),
                    child: readOnlyVal && state is! VerificationLoading
                        ? BlocConsumer<RegisterBloc, RegisterState>(
                            listener: (context, state) {
                              if (state is RegisterSuccess) {
                                readOnly.value = false;
                                error.value = false;
                                seconds.value = 120;
                                startTimer();
                              }
                            },
                            builder: (context, state) {
                              return LoadingButton(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 48,
                                  loading: state is RegisterLoading,
                                  onPressed: () async {
                                    if (context
                                        .read<AuthScreensCubit>()
                                        .inRegister) {
                                      context.read<RegisterBloc>().add(
                                          RegisterUser(
                                              phoneNumber: context
                                                  .read<AuthScreensCubit>()
                                                  .username));
                                    } else {
                                      context.read<RegisterBloc>().add(
                                          LoginUser(
                                              phoneNumber: context
                                                  .read<AuthScreensCubit>()
                                                  .username));
                                    }
                                  },
                                  child: Text(
                                    'ارسال مجدد کد',
                                    style: AppTextStyles.body4,
                                  ));
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'تا دریافت مجدد کد',
                                style: AppTextStyles.body4.copyWith(
                                    color: AppColors.primaryColor[700]),
                              ),
                              ValueListenableBuilder(
                                  valueListenable: seconds,
                                  builder: (context, secVal, _) {
                                    return Text(
                                      ' ${DateTimeUtils.getTimeFromDuration(secVal)}',
                                      style: AppTextStyles.body4.copyWith(
                                          color: AppColors.primaryColor[700]),
                                    );
                                  }),
                              const SizedBox(
                                width: 4,
                              ),
                              Icon(
                                CupertinoIcons.clock,
                                size: 16,
                                color: AppColors.primaryColor[700],
                              )
                            ],
                          ),
                  )
                ],
              );
            });
      },
    );
  }
}
