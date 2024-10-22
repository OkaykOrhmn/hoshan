// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/theme/colors.dart';

class CircleIconBtn extends StatelessWidget {
  final SvgGenImage icon;
  final Function()? onTap;
  final double size;
  final Color? color;
  final Color? iconColor;
  final EdgeInsetsGeometry? iconPadding;
  const CircleIconBtn(
      {super.key,
      required this.icon,
      this.onTap,
      this.size = 32,
      this.color,
      this.iconColor,
      this.iconPadding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: size,
          height: size,
          padding: iconPadding ?? const EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color ?? AppColors.gray[400]),
          child: icon.svg(color: iconColor)),
    );
  }
}
