import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChange;
  final String? hintText;
  final int? maxLength;
  final String? label;
  final Widget? suffix;
  final Widget? error;
  final bool isPassword;

  const AuthTextField(
      {super.key,
      this.hintText,
      this.maxLength,
      this.label,
      this.suffix,
      this.error,
      this.isPassword = false,
      this.controller,
      this.onChange});

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  ValueNotifier<bool> isPassword = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isPassword,
        builder: (context, value, _) {
          return TextField(
            maxLength: widget.maxLength,
            obscureText: widget.isPassword && value,
            style: AppTextStyles.body5,
            controller: widget.controller,
            onChanged: widget.onChange,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyles.body5,
                contentPadding: const EdgeInsets.all(18),
                error: widget.error,
                label: widget.label != null
                    ? Text(
                        widget.label!,
                        style: AppTextStyles.body5.copyWith(
                            color: AppColors.primaryColor.defaultShade),
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? InkWell(
                        child: Icon(
                          value ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                          color: widget.error != null
                              ? AppColors.red.defaultShade
                              : AppColors.primaryColor.defaultShade,
                        ),
                        onTap: () {
                          isPassword.value = !isPassword.value;
                        },
                      )
                    : widget.suffix,
                fillColor: AppColors.primaryColor.defaultShade,
                focusColor: AppColors.primaryColor.defaultShade,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide:
                        BorderSide(color: AppColors.primaryColor.defaultShade)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.red.defaultShade, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.primaryColor.defaultShade, width: 2))),
          );
        });
  }
}
