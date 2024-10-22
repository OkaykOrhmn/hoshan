// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/calender/persian_date_picker.dart';
import 'package:hoshan/ui/widgets/sections/header/reversible_appbar.dart';

class UtilizationReportPage extends StatefulWidget {
  const UtilizationReportPage({super.key});

  @override
  State<UtilizationReportPage> createState() => _UtilizationReportPageState();
}

class _UtilizationReportPageState extends State<UtilizationReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReversibleAppbar(
        titleText: 'گزارش میزان مصرف',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            InkWell(
              onTap: () async {},
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    constraints: const BoxConstraints(minHeight: 56),
                    margin: const EdgeInsets.all(24).copyWith(bottom: 0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor.defaultShade,
                        ),
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin:
                              const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor[50]),
                          child: Assets.icon.outline.calendarEdit
                              .svg(color: AppColors.primaryColor.defaultShade),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16, top: 12, bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '.از تقویم انتخاب کنید',
                                  style: AppTextStyles.body4
                                      .copyWith(color: AppColors.black[200]),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      right: 24 + 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: Text(
                          'تاریخ',
                          style: AppTextStyles.body4.copyWith(
                              color: AppColors.primaryColor.defaultShade),
                        ),
                      ))
                ],
              ),
            ),
            const PersianDatePicker()
          ],
        ),
      ),
    );
  }
}
