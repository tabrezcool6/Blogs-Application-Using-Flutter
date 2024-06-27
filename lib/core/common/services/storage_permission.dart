// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  ///
  ///
  /// Checking External Storage Permission
  static Future<bool> getStoragePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;

    final int androidVersion =
        double.parse(androidInfo.version.release!).truncate();
    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.photos,
      ].request();

      havePermission = request.values.every(
        (status) => status == PermissionStatus.granted,
      );
    } else {
      final status = await [
        Permission.storage,
      ].request();
      havePermission =
          status.values.every((status) => status == PermissionStatus.granted);
    }

    return havePermission;
  }
}



/*

  static Future<bool> getStoragePermission(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      return true;
    } else if (permissionStatus.isDenied) {
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      } else {
        Utils.showSnackBar(context, 'Storage permission is required');
        return false;
      }
    }
    return false;
  }

 */