import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/components/calender/persian_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DialogHandler {
  final BuildContext context;

  DialogHandler({required this.context});

  Future<void> showDatePicker(
      {final Function(List<Jalali>)? onConfirm,
      final Function()? onDismise,
      final int? dateCounts,
      final List<Jalali>? selectedDates}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 2,
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: PersianDatePicker(
                    selectedDates: selectedDates,
                    dateCounts: dateCounts,
                    onConfirm: (p0) {
                      onConfirm?.call(p0);
                      Navigator.pop(context);
                    },
                    dateHeight: 32,
                    onDismise: () {
                      onDismise?.call();

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> showDeleteItem(
      {final String? title,
      final String? description,
      final Function()? onConfirm}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleIconBtn(
                    size: 48,
                    icon: Assets.icon.outline.trash,
                    color: AppColors.red[50],
                    iconColor: AppColors.red[100],
                    iconPadding: const EdgeInsets.all(12),
                  ),
                ),
                if (title != null)
                  Text(
                    title,
                    style: AppTextStyles.headline6,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(
                  height: 4,
                ),
                if (description != null)
                  Text(
                    description,
                    style: AppTextStyles.body4,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingButton(
                        width: MediaQuery.sizeOf(context).width,
                        radius: 32,
                        isOutlined: true,
                        color: AppColors.red.defaultShade,
                        onPressed: () {
                          onConfirm?.call();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'بله',
                          style: AppTextStyles.body4
                              .copyWith(color: AppColors.red.defaultShade),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingButton(
                        width: MediaQuery.sizeOf(context).width,
                        radius: 32,
                        color: AppColors.red.defaultShade,
                        child: Text('خیر',
                            style: AppTextStyles.body4
                                .copyWith(color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
