import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:vk/vk.dart';

class RefundFactorNumDialog {
  static final RefundFactorNumDialog _instance =
      RefundFactorNumDialog.internal();

  RefundFactorNumDialog.internal();

  factory RefundFactorNumDialog() => _instance;

  static void showCustomDialog({required title}) {
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (CartController controller) {
        return Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            children: [
              CustomTextField().createTextField(
                  hint: 'Enter Invoice Number',
                  height: 50,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controller.refundFactorNumController,
                  onSubmitted: (_) async {
                    if (controller.refundFactorNumController.text.isNotEmpty) {
                      Get.back();
                      Get.find<OrderController>().getOrders(
                          id: Get.find<AuthController>().coDetails['prefix'] +
                              controller.refundFactorNumController.text,
                          reqStatus: 'refund');
                    } else {
                      Snack().createSnack(
                          title: 'warning',
                          msg: 'Enter Invoice Number',
                          bgColor: Colors.yellow,
                          msgColor: Colors.black,
                          titleColor: Colors.black);
                    }
                  }),
              Container(
                color: const Color(0xffeeeeee),
                child: VirtualKeyboard(
                  textColor: Colors.black,
                  type: VirtualKeyboardType.Numeric,
                  textController: controller.refundFactorNumController,
                ),
              ),
            ],
          ),
        );
      }),
      contentPadding: const EdgeInsets.all(15),
      confirm: InkWell(
        onTap: () {
          if (Get.find<CartController>()
              .refundFactorNumController
              .text
              .isNotEmpty) {
            Get.back();
            Get.find<OrderController>().getOrders(
                id: Get.find<AuthController>().coDetails['prefix'] +
                    Get.find<CartController>().refundFactorNumController.text,
                reqStatus: 'refund');
          } else {
            Snack().createSnack(
                title: 'warning',
                msg: 'Enter Invoice Number',
                bgColor: Colors.yellow,
                msgColor: Colors.black,
                titleColor: Colors.black);
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
