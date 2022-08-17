// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/address_controller.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/model/string_with_string.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../helper/autocomplete_helper.dart';
import '../../services/model/customer_address_model.dart';

class CustomerAutoCompleteDialog {
  static final CustomerAutoCompleteDialog _instance =
      CustomerAutoCompleteDialog.internal();

  CustomerAutoCompleteDialog.internal();

  factory CustomerAutoCompleteDialog() => _instance;

  static void showCustomDialog(
      {required title, required List<StringWithString> list}) {
    TextEditingController customerController = TextEditingController();
    if (Get.find<CustomerController>().selectedCustomer.toString() != 'null') {
      customerController.text =
          Get.find<CustomerController>().selectedCustomer.mobile ?? '';
    }

    final FocusNode focusNode = FocusNode();
    Get.defaultDialog(
      title: title,
      barrierDismissible: true,
      content: GetBuilder(builder: (ProductController controller) {
        return Column(
          children: [
            TextFieldSearch(
                focusNode: focusNode,
                hasKeyboard: true,
                initialList: list,
                label: 'Customer Name',
                controller: customerController),
            Container(
              width: 900,
              height: 350,
              margin: const EdgeInsets.only(top: 120),
              color: const Color(0xffeeeeee),
              child: VirtualKeyboard(
                focusNode: focusNode,
                textColor: Colors.black,
                type: VirtualKeyboardType.Alphanumeric,
                textController: customerController,
              ),
            ),
          ],
        );
      }),
      contentPadding: const EdgeInsets.all(15),
      confirm: InkWell(
        onTap: () {
          if (Get.find<CustomerController>()
                  .customerList
                  .where((element) => element.name == customerController.text)
                  .first !=
              null) {
            Get.back();
            Get.find<CustomerController>().selectedCustomer =
                Get.find<CustomerController>()
                    .customerList
                    .where((element) => element.name == customerController.text)
                    .first;
            Get.find<CustomerController>().update();
            Get.find<AddressController>().getCustomerAddressRequest(
                customerId: Get.find<CustomerController>()
                    .selectedCustomer
                    .id
                    .toString(),
                hasLoading: true);

            Get.find<CartController>().deliveryAmount = 0.0;
            Get.find<CartController>().selectedCountryName.value = '';
            Get.find<CartController>().selectedCountryId = '';
            Get.find<CartController>().selectedProvinceName.value = '';
            Get.find<CartController>().selectedProvinceId = '';
            Get.find<CartController>().selectedAreaName.value = '';
            Get.find<CartController>().selectedAreaId = '';
            Get.find<CartController>().customerAddressForPrint = '';
            Get.find<CartController>().hasDelivery.value = false;
            Get.find<CartController>().update();
          }
        },
        child: Container(
          width: 90,
          height: 50,
          alignment: Alignment.center,
          color: Colors.green.withOpacity(0.2),
          child: CustomText().createText(title: 'Submit', color: Colors.teal),
        ),
      ),
      cancel: InkWell(
        onTap: () {
          Get.back();

          Get.find<CustomerController>().selectedCustomer = null;

          Get.find<CartController>().deliveryAmount = 0.0;
          Get.find<CartController>().selectedCountryName.value = '';
          Get.find<CartController>().selectedCountryId = '';
          Get.find<CartController>().selectedProvinceName.value = '';
          Get.find<CartController>().selectedProvinceId = '';
          Get.find<CartController>().selectedAreaName.value = '';
          Get.find<CartController>().selectedAreaId = '';
          Get.find<CartController>().update();
          Get.find<CustomerController>().update();
        },
        child: Container(
          width: 90,
          height: 50,
          alignment: Alignment.center,
          color: Colors.red.withOpacity(0.2),
          child: CustomText().createText(title: 'Cancel', color: Colors.red),
        ),
      ),
    );
  }
}
