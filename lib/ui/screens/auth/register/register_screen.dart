import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/data/model/auth/auth_screens_enum.dart';
import 'package:hoshan/ui/screens/auth/cubit/auth_screens_cubit.dart';
import 'package:hoshan/ui/screens/auth/register/bloc/register_bloc.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/components/text/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController number = TextEditingController();
  final ValueNotifier<bool> error = ValueNotifier(false);
  bool canSend = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '.شماره همراه خود را وارد کنید',
          style: AppTextStyles.body4.copyWith(fontWeight: FontWeight.bold),
        ),
        BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              context.read<AuthScreensCubit>().username = number.text;
              context
                  .read<AuthScreensCubit>()
                  .changeState(AuthScreens.verification);
            }
            if (state is RegisterFail) {
              error.value = true;
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ValueListenableBuilder(
                        valueListenable: error,
                        builder: (context, errVal, _) {
                          return AuthTextField(
                            controller: number,
                            onChange: (val) {
                              setState(() =>
                                  canSend = val.length == 11 ? true : false);
                              error.value = false;
                            },
                            maxLength: 11,
                            hintText: 'مثال: 09123456789',
                            label: 'شماره همراه',
                            suffix: const Icon(CupertinoIcons.phone),
                            error: errVal
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: AppColors.red.defaultShade,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          state is RegisterFail &&
                                                  state.error ==
                                                      'The mobile number is already registered'
                                              ? 'کاربر قبلا ثبت نام کرده است لطفا از ورود استفاده کنید'
                                              : 'شماره همراه صحیح نمی باشد .',
                                          style: AppTextStyles.body5.copyWith(
                                              color:
                                                  AppColors.red.defaultShade),
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LoadingButton(
                      width: MediaQuery.sizeOf(context).width,
                      height: 48,
                      loading: state is RegisterLoading,
                      onPressed: canSend
                          ? () {
                              if (context.read<AuthScreensCubit>().inRegister) {
                                context.read<RegisterBloc>().add(
                                    RegisterUser(phoneNumber: number.text));
                              } else {
                                context
                                    .read<RegisterBloc>()
                                    .add(LoginUser(phoneNumber: number.text));
                              }
                            }
                          : null,
                      child: Text(
                        'ارسال کد',
                        style: AppTextStyles.body4,
                      )),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
