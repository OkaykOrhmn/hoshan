// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/ui/screens/splash/cubit/user_info_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/animations/animated_visibility.dart';
import 'package:hoshan/ui/widgets/components/snackbar/snackbar_handler.dart';
import 'package:hoshan/ui/widgets/components/switch/lite_rolling_switch.dart';
import 'package:hoshan/ui/widgets/sections/header/reversible_appbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final ValueNotifier<bool> isDark = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReversibleAppbar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'پروفایل و تنظیمات',
              style: AppTextStyles.body3,
            ),
            const SizedBox(
              width: 8,
            ),
            Assets.icon.outline.setting.svg(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            BlocBuilder<UserInfoCubit, UserInfoState>(
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.gray.defaultShade)),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: AppColors.gray[300],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 6,
                                    color: const Color(0xff4d4d4d)
                                        .withOpacity(0.4))
                              ]),
                          child: UserInfoCubit.userInfoModel.image != null
                              ? Image.network(
                                  UserInfoCubit.userInfoModel.image!)
                              : Assets.icon.outline.profile.svg(),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserInfoCubit.userInfoModel.mobileNumber ??
                                  UserInfoCubit.userInfoModel.username ??
                                  '',
                              style: AppTextStyles.body4,
                            ),
                            Text(
                              'آخرین ورود: 25 اردیبهشت 1403',
                              style: AppTextStyles.body4
                                  .copyWith(color: AppColors.gray[800]),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.editProfile);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    color: AppColors.primaryColor.defaultShade,
                                    size: 18,
                                  ),
                                  Text(
                                    'ویرایش',
                                    style: AppTextStyles.body5.copyWith(
                                        color:
                                            AppColors.primaryColor.defaultShade,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 4,
            ),
            settingContainer(
              title: 'کد معرف',
              icon: Assets.icon.outline.profileUserDoual,
              widget: Text('A812F40', style: AppTextStyles.body4),
              onPressed: () async {
                await Clipboard.setData(const ClipboardData(text: "A812F40"));
                Future.delayed(
                    Duration.zero,
                    () => SnackBarHandler(context)
                        .showInfo(message: 'متن کپی شد 😃', isTop: false));
              },
            ),
            settingContainer(
              title: 'گزارش میزان مصرف',
              icon: Assets.icon.outline.chart,
              onPressed: () {
                Navigator.pushNamed(context, Routes.utilizationReport);
              },
            ),
            settingContainer(
              title: 'حساب من',
              icon: Assets.icon.outline.cardPos,
              onPressed: () {
                Navigator.pushNamed(context, Routes.myAccount);
              },
            ),
            Stack(
              children: [
                settingContainer(
                  title: 'حالت نمایش',
                  icon: Assets.icon.outline.brush,
                  widget: const SizedBox(),
                ),
                Positioned(
                    left: 32,
                    top: 16,
                    bottom: 16,
                    child: ValueListenableBuilder(
                        valueListenable: isDark,
                        builder: (context, dark, _) {
                          return LiteRollingSwitch(
                            value: dark,
                            textOn: '',
                            textOff: '',
                            colorOff: AppColors.secondryColor.defaultShade,
                            colorOn: AppColors.primaryColor.defaultShade,
                            iconOff: Assets.icon.outline.sun.svg(
                              color: AppColors.secondryColor.defaultShade,
                            ),
                            iconOn: Assets.icon.outline.moon.svg(
                              color: AppColors.primaryColor.defaultShade,
                            ),
                            onChanged: (bool state) {
                              //Use it to manage the different states
                              isDark.value = !state;
                            },
                          );
                        }))
              ],
            ),
            Stack(
              children: [
                settingContainer(
                    title: 'دریافت اعلانات',
                    icon: Assets.icon.outline.notificationBing,
                    widget: const SizedBox()),
                Positioned(
                    left: 32,
                    top: 16,
                    bottom: 16,
                    child: LiteRollingSwitch(
                      value: false,
                      textOn: '',
                      textOff: '',
                      colorOn: AppColors.primaryColor.defaultShade,
                      colorOff: AppColors.gray.defaultShade,
                      onChanged: (bool state) {
                        //Use it to manage the different states
                        isDark.value = !state;
                      },
                    ))
              ],
            ),
            settingContainer(
              title: 'پشتیبانی و قوانین',
              icon: Assets.icon.outline.shieldTick,
            ),
            animatedSettingContainer(
                title: 'درباره ما',
                icon: Assets.icon.outline.more,
                childrens: [
                  const SizedBox(
                    height: 24,
                  ),
                  settingContainer(
                    title: 'سایر محصولات',
                    icon: Assets.icon.outline.mobile,
                    notBorder: true,
                    notMargin: true,
                    notPadding: true,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    color: AppColors.gray.defaultShade,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  settingContainer(
                      title: 'تازه‌ترین‌های هوشان',
                      icon: Assets.icon.outline.lampCharge,
                      notBorder: true,
                      notMargin: true,
                      notPadding: true),
                ]),
            settingContainer(
              title: 'ارسال تیکت به پشتیبانی',
              icon: Assets.icon.outline.messages,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'اشتراک گذاری',
                    style: AppTextStyles.body4
                        .copyWith(color: AppColors.primaryColor.defaultShade),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Assets.icon.outline.share
                      .svg(color: AppColors.primaryColor.defaultShade),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'خروج از حساب کاربری',
                    style: AppTextStyles.body4
                        .copyWith(color: AppColors.red.defaultShade),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Assets.icon.outline.login
                      .svg(color: AppColors.red.defaultShade),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }

  Widget settingContainer({
    required final String title,
    required final SvgGenImage icon,
    final Widget? widget,
    final Function()? onPressed,
    final bool notBorder = false,
    final bool notMargin = false,
    final bool notPadding = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: notMargin
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: notPadding
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
            color: Colors.white,
            border: notBorder
                ? null
                : Border.all(color: AppColors.gray.defaultShade),
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget ??
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.secondryColor.defaultShade,
                ),
            Row(
              children: [
                Text(
                  title,
                  style: AppTextStyles.body4,
                ),
                const SizedBox(
                  width: 8,
                ),
                icon.svg(color: AppColors.primaryColor.defaultShade),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget animatedSettingContainer(
      {required final String title,
      required final SvgGenImage icon,
      required final List<Widget> childrens}) {
    final ValueNotifier<bool> show = ValueNotifier(false);
    return InkWell(
      onTap: () {
        show.value = !show.value;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.gray.defaultShade),
            borderRadius: BorderRadius.circular(18)),
        child: ValueListenableBuilder(
          valueListenable: show,
          builder: (context, isVisible, child) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.rotate(
                    angle: (isVisible ? 90 : -90) * pi / 180,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.secondryColor.defaultShade,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body4,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      icon.svg(color: AppColors.primaryColor.defaultShade),
                    ],
                  ),
                ],
              ),
              AnimatedVisibility(
                  isVisible: isVisible,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: childrens,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
