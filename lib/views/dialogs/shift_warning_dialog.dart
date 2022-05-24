import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/shift_controller.dart';
import 'package:pos_system/services/model/area_model.dart';
import 'package:pos_system/services/model/city_model.dart';
import 'package:pos_system/services/model/province_model.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class ShiftWarningDialog {
  static final ShiftWarningDialog _instance = ShiftWarningDialog.internal();

  ShiftWarningDialog.internal();

  factory ShiftWarningDialog() => _instance;

  static void showCustomDialog({required title,required msg}) {
    Get.defaultDialog(title: 'warning',middleText: msg,
      confirm: InkWell(
          onTap: () {
            Get.back();
            Get.find<ShiftController>().endCashRequest();
          },
          child:
          Container(
              width: 110,height: 50,alignment: Alignment.center,
              color: Colors.green.withOpacity(0.2),
              child: CustomText().createText(title: 'Save anyway', color: Colors.teal))),
      cancel: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 110,height: 50,alignment: Alignment.center,
            color: Colors.red.withOpacity(0.2),
            child: CustomText()
                .createText(title: 'Cancel', color: Colors.red),
          )),);
  }
}
