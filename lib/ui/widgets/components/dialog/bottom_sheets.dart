// ignore_for_file: deprecated_member_use_from_same_package

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/services/file_manager/pick_file_services.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';

class BottomSheetHandler {
  final BuildContext context;
  BottomSheetHandler(this.context);

  Future<void> showPickImage({final bool withAvatar = false}) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _sqrBtn(
                  icon: Assets.icon.outline.camera,
                  title: 'دوربین',
                  onTap: () async {
                    await PickFileService.getCameraImage();
                  }),
              const SizedBox(
                width: 24,
              ),
              _sqrBtn(
                  icon: Assets.icon.outline.galleryAdd,
                  title: 'گالری',
                  onTap: () async {
                    await PickFileService.getFile(fileType: FileType.image);
                  }),
              if (withAvatar)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    _sqrBtn(
                        icon: Assets.icon.outline.emojiHappy,
                        title: 'آواتار',
                        onTap: () async {
                          await PickFileService.getFile(
                              fileType: FileType.image);
                        }),
                  ],
                )
            ],
          ),
        );
      },
    );
  }

  Widget _sqrBtn(
      {required final SvgGenImage icon,
      final String? title,
      final Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.gray[400]),
              child: icon.svg(color: AppColors.black.defaultShade)),
          if (title != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 4,
                ),
                Text(
                  title,
                  style: AppTextStyles.body3
                      .copyWith(color: AppColors.primaryColor[800]),
                )
              ],
            )
        ],
      ),
    );
  }
}
