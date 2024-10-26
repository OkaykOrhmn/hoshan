import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/components/calender/persian_date_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DialogHandler {
  final BuildContext context;

  DialogHandler({required this.context});

  Future<void> showDatePicker({
    final Function(List<Jalali>)? onConfirm,
    final int? dateCounts,
  }) async {
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
                    dateCounts: dateCounts,
                    onConfirm: onConfirm,
                    dateHeight: 32,
                    onDismise: () => Navigator.pop(context),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> showDeleteItem(
      {final String? title, final Function()? onConfirm}) async {
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
                Text(
                  'از پاک کردن ${title ?? ''} مطمعن هستید؟',
                  style: AppTextStyles.headline6,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingButton(
                        width: MediaQuery.sizeOf(context).width,
                        radius: 10,
                        color: AppColors.primaryColor.defaultShade,
                        child: Text('خیر',
                            style: AppTextStyles.body4
                                .copyWith(color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingButton(
                        width: MediaQuery.sizeOf(context).width,
                        radius: 10,
                        color: AppColors.red.defaultShade,
                        onPressed: () {
                          onConfirm?.call();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'بله',
                          style:
                              AppTextStyles.body4.copyWith(color: Colors.white),
                        ),
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
