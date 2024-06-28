import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nomadnetshield/helpers/pref.dart';

class MyDialogs {
  static success({required String msg}) {
    Get.snackbar(
      'Success',
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.green.withOpacity(.9),
    );
  }

  static error({required String msg}) {
    Get.snackbar(
      'Error',
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent.withOpacity(.9),
    );
  }

  static info({required String msg}) {
    Get.snackbar(
      'Info',
      msg,
      colorText: Pref.isDarkMode ? Colors.white : const Color(0xFF0D0F14),
      backgroundColor: Pref.isDarkMode
          ? const Color(0xFF0D0F14)
          : Colors.white.withOpacity(.9),
    );
  }

  static showProgress() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          color: Pref.isDarkMode ? Colors.white : const Color(0xFF0D0F14),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
