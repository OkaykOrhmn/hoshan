import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';

class SnackBarHandler {
  final BuildContext context;

  SnackBarHandler(this.context);

  show(String message, bool isTop, MaterialColor color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: AppTextStyles.body4.copyWith(color: color)),
      backgroundColor: color.shade50,
      dismissDirection: DismissDirection.vertical,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 0.5)),
      margin: EdgeInsets.only(
          bottom: isTop ? MediaQuery.of(context).size.height - 90 : 36,
          left: 16,
          right: 16),
    ));
  }

  _showWithColorShades(String message, bool isTop, ColorShades colorShades) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(message,
            style:
                AppTextStyles.body4.copyWith(color: colorShades.defaultShade)),
      ),
      backgroundColor: colorShades[50],
      dismissDirection: DismissDirection.vertical,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorShades.defaultShade, width: 0.5)),
      margin: EdgeInsets.only(
          bottom: isTop ? MediaQuery.of(context).size.height - 90 : 36,
          left: 16,
          right: 16),
    ));
  }

  showSuccess({required final String message, final bool? isTop}) {
    _showWithColorShades(message, isTop ?? true, AppColors.green);
  }

  showInfo({required final String message, final bool? isTop}) {
    _showWithColorShades(message, isTop ?? true, AppColors.primaryColor);
  }

  showError({required final String message, final bool? isTop}) {
    _showWithColorShades(message, isTop ?? true, AppColors.red);
  }
}
