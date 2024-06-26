// ignore_for_file: use_build_context_synchronously

import 'package:blogs_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  ///
  ///
  /// Checking External Storage Permission
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
}
