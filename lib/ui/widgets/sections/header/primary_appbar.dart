import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';

class PrimaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String? titleText;
  const PrimaryAppbar({super.key, this.actions, this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (titleText != null)
            Text(
              titleText!,
              style: AppTextStyles.body3,
            ),
        ],
      ),
      actions: actions,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          HomeCubit.indexed.value = 0;
        },
        child: const Icon(CupertinoIcons.back),
      ),
      shadowColor: AppColors.black.defaultShade.withOpacity(0.15),
      elevation: 4,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}
