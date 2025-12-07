import 'package:permission_handler/permission_handler.dart';

class PermissionServices {
  static Future <bool> requestCallPermissions() async {
    final status =  await Permission.phone.status;

    if (status.isDenied) {
      var result = await Permission.phone.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return status.isGranted;
  }
}