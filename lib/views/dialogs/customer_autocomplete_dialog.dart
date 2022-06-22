import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/model/string_with_string.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:vk/vk.dart';

import '../../helper/autocomplete_helper.dart';

class CustomerAutoCompleteDialog {
  static final CustomerAutoCompleteDialog _instance =
      CustomerAutoCompleteDialog.internal();

  CustomerAutoCompleteDialog.internal();

  factory CustomerAutoCompleteDialog() => _instance;

  static void showCustomDialog(
      {required title, required List<StringWithString> list}) {
    TextEditingController customerController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Column(
          children: [
            TextFieldSearch(
                focusNode: focusNode,
                hasKeyboard: true,
                initialList: list,
                label: 'Customer Name',
                controller: customerController),
            // Container(
            //   width: 900,
            //   margin: const EdgeInsets.only(top: 120),
            //   color: const Color(0xffeeeeee),
            //   child: VirtualKeyboard(
            //     focusNode: focusNode,
            //     textColor: Colors.black,
            //     type: VirtualKeyboardType.Alphanumeric,
            //     textController: customerController,
            //   ),
            // ),
          ],
        );
      }),
      contentPadding: const EdgeInsets.all(15),
      confirm: InkWell(
        onTap: () {
          Get.find<CustomerController>().selectedCustomer =
              Get.find<CustomerController>()
                  .customerList
                  .where((element) => element.name == customerController.text)
                  .first;
          Get.find<CustomerController>().update();
          Get.back();
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
        onTap: () => Get.back(),
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
