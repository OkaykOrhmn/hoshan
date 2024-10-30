// ignore_for_file: deprecated_member_use_from_same_package, use_build_context_synchronously

import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/services/api/dio_service.dart';
import 'package:hoshan/data/repository/auth_repository.dart';
import 'package:hoshan/ui/screens/setting/cubit/check_username_cubit.dart';
import 'package:hoshan/ui/screens/splash/cubit/user_info_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/components/dialog/bottom_sheets.dart';
import 'package:hoshan/ui/widgets/components/image/network_image.dart';
import 'package:hoshan/ui/widgets/components/snackbar/snackbar_handler.dart';
import 'package:hoshan/ui/widgets/components/text/auth_text_field.dart';
import 'package:hoshan/ui/widgets/sections/header/reversible_appbar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController username = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pasword = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  String? imageUrl;
  final ValueNotifier<XFile?> image = ValueNotifier(null);
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReversibleAppbar(
        titleText: 'ویرایش پروفایل',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocConsumer<UserInfoCubit, UserInfoState>(
          listener: (context, state) {},
          builder: (context, state) {
            imageUrl = UserInfoCubit.userInfoModel.image;

            if (UserInfoCubit.userInfoModel.username != null) {
              username.text = UserInfoCubit.userInfoModel.username!;
            }
            if (UserInfoCubit.userInfoModel.mobileNumber != null) {
              mobile.text = UserInfoCubit.userInfoModel.mobileNumber!;
            }
            if (UserInfoCubit.userInfoModel.email != null) {
              email.text = UserInfoCubit.userInfoModel.email!;
            }

            return Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: image,
                          builder: (context, date, _) {
                            return Container(
                              width: 140,
                              height: 140,
                              margin:
                                  const EdgeInsets.only(top: 24, bottom: 40),
                              decoration: BoxDecoration(
                                  color: AppColors.gray[300],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6,
                                        color: const Color(0xff4d4d4d)
                                            .withOpacity(0.4))
                                  ]),
                              child: ClipOval(
                                child: date != null
                                    ? Image.file(
                                        File(date.path),
                                        fit: BoxFit.cover,
                                      )
                                    : imageUrl != null && imageUrl!.isNotEmpty
                                        ? ImageNetwork(
                                            url: DioService.baseURL + imageUrl!,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(32),
                                            child:
                                                Assets.icon.bold.profile.svg(),
                                          ),
                              ),
                            );
                          }),
                      Positioned(
                        bottom: 0 + 40,
                        left: 0,
                        child: CircleIconBtn(
                          icon: Assets.icon.outline.galleryAdd,
                          color: AppColors.secondryColor.defaultShade,
                          iconColor: Colors.white,
                          size: 48,
                          iconPadding: const EdgeInsets.all(10),
                          onTap: () =>
                              BottomSheetHandler(context).showPickImage(
                            withAvatar: true,
                            profile: true,
                            onSelect: (file) {
                              image.value = file;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        BlocBuilder<CheckUsernameCubit, CheckUsernameState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                AuthTextField(
                                  success: state is CheckUsernameSuccess
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color:
                                                  AppColors.green.defaultShade,
                                              size: 16,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'نام کاربری در دسترس است',
                                                style: AppTextStyles.body5
                                                    .copyWith(
                                                        color: AppColors.green
                                                            .defaultShade),
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                  error: state is CheckUsernameFail
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
                                                'نام کاربری قبلا انتخاب شده است',
                                                style: AppTextStyles.body5
                                                    .copyWith(
                                                        color: AppColors
                                                            .red.defaultShade),
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                  label: 'نام کاربری',
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Assets.icon.outline.profileTick.svg(
                                        color: state is CheckUsernameFail
                                            ? AppColors.red.defaultShade
                                            : state is CheckUsernameSuccess
                                                ? AppColors.green.defaultShade
                                                : AppColors
                                                    .primaryColor.defaultShade),
                                  ),
                                  controller: username,
                                  onChange: (usernameText) {
                                    if (usernameText.isEmpty) {
                                      return;
                                    }
                                    context
                                        .read<CheckUsernameCubit>()
                                        .loading();
                                    EasyDebounce.debounce(
                                        'my-username', // <-- An ID for this particular debouncer
                                        const Duration(
                                            seconds:
                                                1), // <-- The debounce duration
                                        () {
                                      context
                                          .read<CheckUsernameCubit>()
                                          .check(usernameText);
                                    } // <-- The target method
                                        );
                                  },
                                ),
                                if (state is CheckUsernameLoading)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 4),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            color: AppColors
                                                .primaryColor.defaultShade,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'درحال بررسی',
                                            style: AppTextStyles.body5.copyWith(
                                                color: AppColors
                                                    .primaryColor.defaultShade),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        AuthTextField(
                          label: 'تلفن همراه',
                          enabled: false,
                          suffix: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Assets.icon.outline.call.svg(
                                color: AppColors.primaryColor.defaultShade),
                          ),
                          controller: mobile,
                        ),
                        // const SizedBox(
                        //   height: 24,
                        // ),
                        // AuthTextField(
                        //   label: 'آدرس ایمیل',
                        //   suffix: Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: Assets.icon.outline.smsTracking.svg(),
                        //   ),
                        //   controller: email,
                        // ),
                        const SizedBox(
                          height: 24,
                        ),
                        AuthTextField(
                          label: 'رمز عبور',
                          suffix: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Assets.icon.outline.lock.svg(
                                color: pasword.text != rePassword.text
                                    ? AppColors.red.defaultShade
                                    : AppColors.primaryColor.defaultShade),
                          ),
                          controller: pasword,
                          error: pasword.text != rePassword.text
                              ? const SizedBox()
                              : null,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        AuthTextField(
                          label: 'تکرار رمز عبور',
                          suffix: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Assets.icon.outline.lock.svg(
                                color: pasword.text != rePassword.text
                                    ? AppColors.red.defaultShade
                                    : AppColors.primaryColor.defaultShade),
                          ),
                          controller: rePassword,
                          error: pasword.text != rePassword.text
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        'رمز عبور با تکرار آن مطابقت ندارد',
                                        style: AppTextStyles.body5.copyWith(
                                            color: AppColors.red.defaultShade),
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ValueListenableBuilder(
                            valueListenable: loading,
                            builder: (context, data, _) {
                              return LoadingButton(
                                width: MediaQuery.sizeOf(context).width,
                                height: 40,
                                color: AppColors.primaryColor.defaultShade,
                                loading: data,
                                radius: 24,
                                onPressed: data
                                    ? null
                                    : () async {
                                        setState(() {});
                                        loading.value = true;

                                        if (pasword.text != rePassword.text) {
                                          loading.value = false;
                                          return;
                                        }
                                        bool? chUsernameChange;
                                        if (username.text !=
                                            UserInfoCubit
                                                .userInfoModel.username!) {
                                          chUsernameChange =
                                              await AuthRepository.editUsername(
                                                  username.text);
                                        }
                                        bool? chPassswordChange;
                                        if (pasword.text.isNotEmpty) {
                                          chPassswordChange =
                                              await AuthRepository
                                                  .editPasswordProfile(
                                                      pasword.text);
                                        }
                                        bool? chImageChange;
                                        if (image.value != null) {
                                          chImageChange = await AuthRepository
                                              .editImageProfile(image.value!);
                                        }
                                        if (chUsernameChange != null &&
                                            !chUsernameChange) {
                                          await SnackBarHandler(context).showError(
                                              message:
                                                  'خطا در تغییر نام کاربری دوباره سعی کنید',
                                              isTop: false);
                                        }
                                        if (chPassswordChange != null &&
                                            !chPassswordChange) {
                                          await SnackBarHandler(context).showError(
                                              message:
                                                  'خطا در تغییر رمز دوباره سعی کنید',
                                              isTop: false);
                                        }
                                        if (chImageChange != null &&
                                            (!chImageChange)) {
                                          await SnackBarHandler(context).showError(
                                              message:
                                                  'خطا در آپلود فایل دوباره سعی کنید',
                                              isTop: false);
                                        }
                                        context
                                            .read<UserInfoCubit>()
                                            .getUserInfo();
                                        loading.value = false;
                                      },
                                child: Text(
                                  'تایید',
                                  style: AppTextStyles.body4
                                      .copyWith(color: Colors.white),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
