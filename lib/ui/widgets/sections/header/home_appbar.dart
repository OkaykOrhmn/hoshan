// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                CircleIconBtn(
                  icon: Assets.icon.bold.setting,
                  color: AppColors.primaryColor[50],
                  iconColor: AppColors.primaryColor.defaultShade,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.setting);
                  },
                ),
              ],
            ),
          ),
          Flexible(child: Center(child: Assets.image.appIconPrimary.svg())),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '300',
                    style: AppTextStyles.body4,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                CircleIconBtn(
                  icon: Assets.icon.outline.coin,
                  color: AppColors.secondryColor[50],
                  iconColor: AppColors.secondryColor.defaultShade,
                ),
              ],
            ),
          ),
        ],
      ),
      shadowColor: AppColors.gray.defaultShade,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
