import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/data/model/auth_screens_enum.dart';
import 'package:hoshan/ui/screens/auth/cubit/auth_screens_cubit.dart';
import 'package:hoshan/ui/screens/auth/login/bloc/login_bloc.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/components/text/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool typeUser = false;
  bool typePassword = false;
  bool? isPasswordIncorrect;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushNamed(context, Routes.home);
        }
      },
      builder: (context, state) {
        if (state is LoginFail) {
          isPasswordIncorrect = state.isPasswordIncorrect;
        }
        return Column(
          children: [
            Text(
              '.نام کاربری و رمز عبور خود را وارد کنید',
              style: AppTextStyles.body4.copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: AuthTextField(
                    hintText: 'مثال: Ali',
                    label: 'نام کاربری',
                    controller: username,
                    error:
                        isPasswordIncorrect != null && !(isPasswordIncorrect!)
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: AppColors.red.defaultShade,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'نام کاربری صحیح نمی باشد .',
                                    style: AppTextStyles.body5.copyWith(
                                        color: AppColors.red.defaultShade),
                                  ),
                                ],
                              )
                            : null,
                    onChange: (val) {
                      setState(() => typeUser = val.length > 4 ? true : false);
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: AuthTextField(
                    label: 'رمز عبور',
                    isPassword: true,
                    controller: password,
                    onChange: (val) {
                      setState(
                          () => typePassword = val.length > 8 ? true : false);
                    },
                    error: isPasswordIncorrect != null && (isPasswordIncorrect!)
                        ? Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.red.defaultShade,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'رمز عبور صحیح نمی باشد .',
                                style: AppTextStyles.body5.copyWith(
                                    color: AppColors.red.defaultShade),
                              ),
                            ],
                          )
                        : null,
                  )),
            ),
            InkWell(
              onTap: () {},
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18, right: 20),
                  child: Text(
                    'رمز عبور خود را فراموش کردید؟',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor.defaultShade),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LoadingButton(
                  width: MediaQuery.sizeOf(context).width,
                  height: 48,
                  loading: state is LoginLoading,
                  onPressed: typeUser && typePassword
                      ? () {
                          context.read<LoginBloc>().add(LoginWithPassword(
                              username: username.text,
                              password: password.text));
                        }
                      : null,
                  child: Text(
                    'ورود',
                    style: AppTextStyles.body4,
                  )),
            ),
            InkWell(
              onTap: () {
                context
                    .read<AuthScreensCubit>()
                    .changeState(AuthScreens.mobile);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Text(
                  'ورود با کد یکبار مصرف',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor.defaultShade),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
