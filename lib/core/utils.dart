import 'dart:io';

import 'package:blogs_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  static Future<File?> pickImage() async {
    try {
      final xFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (xFile != null) {
        return File(xFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static int calculateReadTime(String content) {
    final wordCount = content.split(RegExp(r'\s+')).length;

    final readingTime = wordCount / 225; // speed = distance/time

    return readingTime.ceil();
  }

  static String formatDateBydMMMYYYY(DateTime dateTime) {
    return DateFormat("d MMM, yyyy").format(dateTime);
  }

  ///
  ///
  /// Dual Button Alert Dialog Box
  static singleBtnPopAlertDialogBox({
    required BuildContext context,
    required String title,
    required String desc,
    // required String btnText1,
    required Function() onTap1,
    // required String btnText2,
    // required Function() onTap2,
  }) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: onTap1,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text('OK', style: TextStyle(color: AppPallete.blue)),
    );
    // set up the button
    Widget reportButton = TextButton(
      onPressed: () => Navigator.pop(context),
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: const Text('Cancel', style: TextStyle(color: Colors.red)),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      // content: Text(desc),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      actions: [reportButton, okButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () => Future.value(false), child: alert);
      },
    );
  }
}
