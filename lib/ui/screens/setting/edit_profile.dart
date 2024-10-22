// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/screens/splash/cubit/user_info_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/components/dialog/bottom_sheets.dart';
import 'package:hoshan/ui/widgets/components/image/network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReversibleAppbar(
        titleText: 'ویرایش پروفایل',
      ),
      body: BlocConsumer<UserInfoCubit, UserInfoState>(
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
                    Container(
                      width: 140,
                      height: 140,
                      margin: const EdgeInsets.only(top: 24, bottom: 40),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                          color: AppColors.gray[300],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6,
                                color: const Color(0xff4d4d4d).withOpacity(0.4))
                          ]),
                      child: imageUrl != null && imageUrl!.isNotEmpty
                          ? Expanded(
                              child: ImageNetwork(
                              url: imageUrl!,
                            ))
                          : Assets.icon.bold.profile.svg(),
                    ),
                    Positioned(
                      bottom: 0 + 40,
                      left: 0,
                      child: CircleIconBtn(
                        icon: Assets.icon.outline.galleryAdd,
                        color: AppColors.secondryColor.defaultShade,
                        iconColor: Colors.white,
                        size: 48,
                        iconPadding: const EdgeInsets.all(10),
                        onTap: () => BottomSheetHandler(context)
                            .showPickImage(withAvatar: true),
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
                      AuthTextField(
                        label: 'نام کاربری',
                        suffix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Assets.icon.outline.profileTick.svg(),
                        ),
                        controller: username,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AuthTextField(
                        label: 'تلفن همراه',
                        suffix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Assets.icon.outline.call
                              .svg(color: AppColors.primaryColor.defaultShade),
                        ),
                        controller: mobile,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AuthTextField(
                        label: 'آدرس ایمیل',
                        suffix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Assets.icon.outline.smsTracking.svg(),
                        ),
                        controller: email,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AuthTextField(
                        label: 'رمز عبور',
                        suffix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Assets.icon.outline.lock
                              .svg(color: AppColors.primaryColor.defaultShade),
                        ),
                        controller: pasword,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AuthTextField(
                        label: 'تکرار رمز عبور',
                        suffix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Assets.icon.outline.lock
                              .svg(color: AppColors.primaryColor.defaultShade),
                        ),
                        controller: rePassword,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      LoadingButton(
                        width: MediaQuery.sizeOf(context).width,
                        height: 40,
                        color: AppColors.primaryColor.defaultShade,
                        child: Text(
                          'تایید',
                          style:
                              AppTextStyles.body4.copyWith(color: Colors.white),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
