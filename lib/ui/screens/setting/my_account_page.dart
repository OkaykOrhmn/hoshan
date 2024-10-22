// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/sections/header/reversible_appbar.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReversibleAppbar(
        titleText: 'حساب من',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: cardInfo(
                    icon: Assets.icon.outline.coin,
                    title: 'اعتبار باقی مانده',
                    value: '12000 توکن',
                    btnTitle: 'مشاهده جزئیات',
                    onClick: () {},
                  ),
                ),
                Expanded(
                  child: cardInfo(
                    icon: Assets.icon.outline.emptyWalletTick,
                    title: 'موجودی حساب',
                    value: ' 281000 تومان',
                    btnTitle: 'ارتقای حساب',
                    onClick: () {},
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    CircleIconBtn(
                      icon: Assets.icon.bulk.gift,
                      size: 80,
                      iconPadding: const EdgeInsets.all(12),
                      color: AppColors.primaryColor.defaultShade,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'امتیاز وفاداری',
                            style: AppTextStyles.body3.copyWith(
                                color: AppColors.primaryColor.defaultShade,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'معادل 10% تخفیف در خرید بعدی و یا شارژ 200 توکن برای ابزار تولید عکس',
                            style: AppTextStyles.body4
                                .copyWith(color: AppColors.black.defaultShade),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 4, 8, 4),
                                  decoration: BoxDecoration(
                                      color:
                                          AppColors.primaryColor.defaultShade,
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(4),
                                          topRight: Radius.circular(4))),
                                  child: Row(
                                    children: [
                                      Assets.icon.outline.documentCopy
                                          .svg(color: Colors.white),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        'کپی',
                                        style: AppTextStyles.body4
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 12, 4),
                                  decoration: BoxDecoration(
                                      color: AppColors.gray[200],
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                          topLeft: Radius.circular(4))),
                                  child: Text(
                                    '2AZ5H',
                                    style: AppTextStyles.body4
                                        .copyWith(color: AppColors.gray[700]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container cardInfo(
      {required final SvgGenImage icon,
      required final String title,
      required final String value,
      required final String btnTitle,
      final Function()? onClick}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          CircleIconBtn(
            size: 48,
            iconPadding: const EdgeInsets.all(8),
            icon: icon,
            color: AppColors.secondryColor[50],
            iconColor: AppColors.secondryColor.defaultShade,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: AppTextStyles.body4.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black.defaultShade),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            value,
            style: AppTextStyles.body4.copyWith(color: AppColors.black[400]),
          ),
          const SizedBox(
            height: 12,
          ),
          LoadingButton(
            color: AppColors.gray[200],
            onPressed: onClick,
            radius: 8,
            child: Text(
              btnTitle,
              style: AppTextStyles.body4
                  .copyWith(color: AppColors.primaryColor.defaultShade),
            ),
          )
        ],
      ),
    );
  }
}
