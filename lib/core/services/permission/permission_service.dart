import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> getPermission(
      {required final Permission permission}) async {
    await permission.onDeniedCallback(() {
      // Your code
    }).onGrantedCallback(() {
      // Your code
    }).onPermanentlyDeniedCallback(() {
      // Your code
    }).onRestrictedCallback(() {
      // Your code
    }).onLimitedCallback(() {
      // Your code
    }).onProvisionalCallback(() {
      // Your code
    }).request();
    final status = await permission.status;
    return status.isGranted;
  }
}
