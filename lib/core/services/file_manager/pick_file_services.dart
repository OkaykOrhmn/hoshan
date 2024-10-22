import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hoshan/core/services/permission/permission_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickFileService {
  static Future<List<XFile>?> getFile(
      {required final FileType fileType,
      bool allowMultiple = false,
      final Function(FilePickerStatus)? onFileLoading}) async {
    try {
      await PermissionService.getPermission(permission: Permission.storage);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: fileType,
        onFileLoading: onFileLoading,
      );
      final files = result!.xFiles;
      return files;
    } catch (e) {
      if (kDebugMode) {
        print("PickFileService Error: $e");
      }
      return null;
    }
  }

  static Future<XFile?> getCameraImage() async {
    await PermissionService.getPermission(permission: Permission.camera);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    return image;
  }
}
