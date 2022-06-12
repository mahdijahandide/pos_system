import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snack {
  createSnack(
      {dynamic title,
      dynamic msg,
      dynamic icon,
      dynamic bgColor,
      dynamic titleColor,
      dynamic msgColor}) {
    return Get.snackbar('', '',
        backgroundColor: bgColor ?? Colors.black,
        duration: const Duration(seconds: 3),
        titleText: Text(
          '$title',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: titleColor ?? Colors.white),
        ),
        messageText: Text(
          '$msg',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: msgColor ?? Colors.white),
        ),
        icon: icon ??
            const Icon(
              Icons.error,
              color: Colors.black,
            ));
  }
}
