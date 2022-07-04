import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:read_barcode/read_barcode.dart';
import 'package:universal_html/html.dart';

class DashboardController extends GetxController {
  RxBool isShowKeyboard = false.obs;
  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  TextEditingController searchController = TextEditingController();

  RxInt searchId = 1.obs;

  RxBool showProductDetails = false.obs;

  final barcodeReader = BarcodeReader();
  RxBool enterPressed = false.obs;

  RxString barcodeResult = ''.obs;

  RxBool isFullScreen = false.obs;

  void listener() {
    print(barcodeReader.keycode);
    barcodeReader.keycode.last == 'Enter'
        ? enterPressed.value = true
        : barcodeResult.value = barcodeReader.keycode.join();
    barcodeReader.keycode.clear();
    update();
  }

  void changeSearchType({required id}) {
    searchId.value = id;
    update();
  }

  void fullScreen() {
    document.documentElement!.requestFullscreen();
    if (document.fullscreenEnabled == true) {
      document.exitFullscreen();
    } else {
      document.documentElement!.requestFullscreen();
    }
    Timer.periodic(const Duration(seconds: 1),
        (Timer t) => Get.find<ProductController>().hasProduct.value = true);
    Get.find<ProductController>().update();
  }
}
