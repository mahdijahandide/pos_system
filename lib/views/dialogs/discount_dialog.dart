import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:vk/vk.dart';

class DiscountDialog {
  static final DiscountDialog _instance = DiscountDialog.internal();

  DiscountDialog.internal();

  factory DiscountDialog() => _instance;

  static void showCustomDialog({required title}) {
    TextEditingController discountController = TextEditingController();
    RxBool isPercent = false.obs;
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      isPercent = true.obs;
                      controller.update();
                    },
                    child: Container(
                      width: 100,
                      height: 65,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      color: isPercent.isTrue
                          ? Colors.green.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.5),
                      child: Center(
                          child: CustomText().createText(
                              title: '%',
                              size: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      isPercent = false.obs;
                      controller.update();
                    },
                    child: Container(
                      width: 100,
                      height: 65,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      color: isPercent.isFalse
                          ? Colors.green.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.5),
                      child: Center(
                          child: CustomText().createText(
                              title: '\$',
                              size: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField().createTextField(
                  hint: 'Enter Discount Amount',
                  autoFocus: true,
                  height: 50,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: discountController,
                  onSubmitted: (_) async {
                    if (isPercent.isFalse) {
                      Get.find<CartController>().discountAmount =
                          double.parse(discountController.text.toString());
                    } else {
                      Get.find<CartController>().discountAmount =
                          (Get.find<CartController>().totalAmount *
                                  double.parse(
                                      discountController.text.toString())) /
                              100;
                    }
                    Get.find<CartController>().getTempOrders(
                        cartId: Get.find<CartController>().uniqueId.toString(),
                        areaId: Get.find<CartController>()
                            .selectedAreaId
                            .toString(),
                        userDiscount: Get.find<CartController>()
                            .discountAmount
                            .toString());
                    // Get.back();
                    // Get.find<CartController>().update();
                  }),
              Container(
                color: const Color(0xffeeeeee),
                child: VirtualKeyboard(
                  focusNode: FocusNode(),
                  textColor: Colors.black,
                  type: VirtualKeyboardType.Numeric,
                  textController: discountController,
                ),
              ),
            ],
          ),
        );
      }),
      contentPadding: const EdgeInsets.all(15),
      confirm: InkWell(
        onTap: () {
          if (isPercent.isFalse) {
            Get.find<CartController>().discountAmount =
                double.parse(discountController.text.toString());
          } else {
            Get.find<CartController>().discountAmount =
                (Get.find<CartController>().totalAmount *
                        double.parse(discountController.text.toString())) /
                    100;
          }
          Get.find<CartController>().getTempOrders(
              cartId: Get.find<CartController>().uniqueId.toString(),
              areaId: Get.find<CartController>().selectedAreaId.toString(),
              userDiscount:
                  Get.find<CartController>().discountAmount.toString());
          Get.find<CartController>().saveCartForSecondMonitor();
          // Get.back();
          // Get.find<CartController>().update();
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
