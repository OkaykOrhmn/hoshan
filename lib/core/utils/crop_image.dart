import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:image_cropper/image_cropper.dart';

class CropImage {
  Future<XFile?> getCroppedFile(
      {required final BuildContext context,
      required final String sourcePath,
      final CropAspectRatioPresetData? aspectRatioPresets}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'برش عکس',
            activeControlsWidgetColor: AppColors.primaryColor.defaultShade,
            toolbarColor: AppColors.primaryColor.defaultShade,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            initAspectRatio: aspectRatioPresets,
            aspectRatioPresets: aspectRatioPresets != null
                ? [aspectRatioPresets]
                : const [
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ]),
        IOSUiSettings(
          title: 'برش عکس',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    XFile? result;
    if (croppedFile != null) {
      result = XFile(croppedFile.path);
    }
    return result;
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (1, 1);

  @override
  String get name => '1x1 (customized)';
}
