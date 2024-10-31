// ignore_for_file: deprecated_member_use_from_same_package, use_build_context_synchronously

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/services/file_manager/pick_file_services.dart';
import 'package:hoshan/core/utils/crop_image.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:image_cropper/image_cropper.dart';

class BottomSheetHandler {
  final BuildContext context;
  BottomSheetHandler(this.context);

  Future<void> showStringList(
      {required final List<String> values,
      required final String title,
      final Function(String)? onSelect}) async {
    final ScrollController scrollController = ScrollController();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        width: MediaQuery.sizeOf(context).width,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height / 2.4),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 32,
            ),
            Text(
              title,
              style: AppTextStyles.body3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  controller: scrollController,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: List.generate(
                        values.length,
                        (index) => InkWell(
                          onTap: () {
                            onSelect?.call(values[index]);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Text(
                                  values[index],
                                  style: AppTextStyles.body4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPickImage(
      {final bool withAvatar = false,
      final Function(XFile)? onSelect,
      final bool profile = false}) async {
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
                    XFile? file = await PickFileService.getCameraImage();
                    if (file != null) {
                      file = await CropImage().getCroppedFile(
                          context: context,
                          sourcePath: file.path,
                          aspectRatioPresets:
                              profile ? CropAspectRatioPreset.square : null);
                      if (file != null) {
                        onSelect?.call(file);
                      }
                      Navigator.pop(context);
                    }
                  }),
              const SizedBox(
                width: 24,
              ),
              _sqrBtn(
                  icon: Assets.icon.outline.galleryAdd,
                  title: 'گالری',
                  onTap: () async {
                    final file =
                        await PickFileService.getFile(fileType: FileType.image);
                    if (file != null) {
                      final croppedFile = await CropImage().getCroppedFile(
                          context: context,
                          sourcePath: file.single.path,
                          aspectRatioPresets:
                              profile ? CropAspectRatioPreset.square : null);
                      if (croppedFile != null) {
                        onSelect?.call(file.single);
                      }
                      Navigator.pop(context);
                    }
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
                          final file = await PickFileService.getFile(
                              fileType: FileType.image);
                          if (file != null) {
                            onSelect?.call(file.single);
                            Navigator.pop(context);
                          }
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
