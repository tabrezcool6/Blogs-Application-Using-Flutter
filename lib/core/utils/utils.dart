import 'dart:io';

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
}
