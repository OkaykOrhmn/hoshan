import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';

class SimpleDropdown extends StatelessWidget {
  final String? hintText;
  final String? initialItem;
  final List<String> list;
  final Function(int)? onSelect;
  final double? width;
  final double? height;
  const SimpleDropdown({
    super.key,
    this.hintText,
    required this.list,
    this.onSelect,
    this.width,
    this.height,
    this.initialItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomDropdown<String>(
        decoration: CustomDropdownDecoration(
            headerStyle:
                AppTextStyles.body4.copyWith(color: AppColors.black[900]),
            listItemStyle:
                AppTextStyles.body4.copyWith(color: AppColors.black[900])),
        hintText: hintText,
        items: list,
        initialItem: initialItem ?? list[0],
        onChanged: (p0) {
          final index = list.indexOf(p0 ?? '');

          onSelect?.call(index);
        },
      ),
    );
  }
}
