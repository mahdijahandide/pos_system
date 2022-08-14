import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/address_controller.dart';
import 'package:pos_system/services/controller/shift_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class DeleteDialog {
  static final DeleteDialog _instance = DeleteDialog.internal();

  DeleteDialog.internal();

  factory DeleteDialog() => _instance;

  static void showCustomDialog(
      {required title,
      required msg,
      required String customerId,
      required String addressId}) {
    Get.defaultDialog(
      title: title,
      middleText: msg,
      confirm: InkWell(
          onTap: () {
            Get.back();
            Get.find<AddressController>().deleteCustomerAddressRequest(
                customerId: customerId, addressId: addressId);
          },
          child: Container(
              width: 110,
              height: 50,
              alignment: Alignment.center,
              color: Colors.green.withOpacity(0.2),
              child: CustomText()
                  .createText(title: 'Delete', color: Colors.teal))),
      cancel: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 110,
            height: 50,
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.2),
            child: CustomText().createText(title: 'Cancel', color: Colors.red),
          )),
    );
  }
}
