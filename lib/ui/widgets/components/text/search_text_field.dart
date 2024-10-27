import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';

class SearchTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final String? hintText;
  final String? label;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  SearchTextField(
      {super.key,
      this.onChanged,
      this.hintText,
      this.label,
      this.suffixIcon,
      this.controller});

  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.gray.defaultShade));

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          style: AppTextStyles.body5,
          onChanged: onChanged,
          decoration: InputDecoration(
              hintText: hintText ?? 'جستجو',
              hintStyle: AppTextStyles.body5,
              contentPadding: const EdgeInsets.all(18),
              label: Text(
                label ?? 'جستجو',
                style: AppTextStyles.body5
                    .copyWith(color: AppColors.primaryColor.defaultShade),
              ),
              suffixIcon: suffixIcon,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Assets.icon.outline.searchNormal.svg(),
              ),
              fillColor: AppColors.primaryColor.defaultShade,
              focusColor: AppColors.primaryColor.defaultShade,
              border: outlineInputBorder,
              errorBorder: outlineInputBorder.copyWith(
                  borderSide:
                      BorderSide(color: AppColors.red.defaultShade, width: 2)),
              focusedBorder: outlineInputBorder.copyWith(
                  borderSide: BorderSide(
                      color: AppColors.primaryColor.defaultShade, width: 2))),
        ),
      ),
    );
  }
}
