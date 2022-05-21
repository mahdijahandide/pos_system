import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoadingDialog {
  static final LoadingDialog _instance = LoadingDialog.internal();

  LoadingDialog.internal();

  factory LoadingDialog() => _instance;

  static void showCustomDialog({required msg}) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: '$msg',
      backgroundColor: Colors.white,
      content: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          margin: const EdgeInsets.only(top: 15.0),
          child: const CircularProgressIndicator()),
    );
  }
}
