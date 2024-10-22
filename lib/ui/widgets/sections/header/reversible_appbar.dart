import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';

class ReversibleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  const ReversibleAppbar({super.key, this.title, this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          title ??
              Text(
                titleText ?? '',
                style: AppTextStyles.body3,
              ),
        ],
      ),
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(CupertinoIcons.back),
      ),
      shadowColor: AppColors.black.defaultShade.withOpacity(0.15),
      elevation: 4,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
