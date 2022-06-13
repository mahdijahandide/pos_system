import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:vk/vk.dart';

class EditQtyDialog {
  static final EditQtyDialog _instance = EditQtyDialog.internal();

  EditQtyDialog.internal();

  factory EditQtyDialog() => _instance;

  static void showCustomDialog({required title, required productId}) {
    TextEditingController qtyController = TextEditingController();
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            children: [
              CustomTextField().createTextField(
                  hint: 'Enter New Quantity',
                  height: 50,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: qtyController,
                  onSubmitted: (_) async {
                    var current = Get.find<CartController>()
                        .addToCartList
                        .value
                        .where((element) =>
                            element.productId == productId.toString())
                        .toList()[0];
                    if (int.parse(qtyController.text.toString()) >
                        int.parse(Get.find<ProductController>()
                            .productList
                            .value
                            .where((element) => element.id == current.id)
                            .first
                            .quantity
                            .toString())) {
                      Snack().createSnack(
                          title:
                              'selected quantity is bigger than existed item quantity',
                          msg: '',
                          bgColor: Colors.yellow,
                          msgColor: Colors.black,
                          titleColor: Colors.black);
                    } else {
                      Get.find<CartController>().editCartProductQuantity(
                          tempId: current.productId,
                          quantity: qtyController.text,
                          tempUniqueId: Get.find<CartController>().uniqueId,
                          index: Get.find<CartController>()
                              .addToCartList
                              .value
                              .indexWhere((element) =>
                                  element.productId == current.productId));
                    }
                  }),
              Container(
                color: const Color(0xffeeeeee),
                child: VirtualKeyboard(
                  textColor: Colors.black,
                  type: VirtualKeyboardType.Numeric,
                  textController: qtyController,
                ),
              ),
            ],
          ),
        );
      }),
      contentPadding: const EdgeInsets.all(15),
      confirm: InkWell(
        onTap: () {
          var current = Get.find<CartController>()
              .addToCartList
              .value
              .where((element) => element.productId == productId.toString())
              .toList()[0];

          if (int.parse(qtyController.text.toString()) >
              int.parse(Get.find<ProductController>()
                  .productList
                  .value
                  .where((element) =>
                      element.id!.toInt() ==
                      int.parse(current.productId.toString()))
                  .first
                  .quantity
                  .toString())) {
            Snack().createSnack(
                title: 'selected quantity is bigger than existed item quantity',
                msg: '',
                bgColor: Colors.yellow,
                msgColor: Colors.black,
                titleColor: Colors.black);
          } else {
            Get.find<CartController>().editCartProductQuantity(
                tempId: current.id.toString(),
                quantity: qtyController.text,
                tempUniqueId: Get.find<CartController>().uniqueId,
                index: Get.find<CartController>()
                    .addToCartList
                    .value
                    .indexWhere(
                        (element) => element.productId == current.productId));
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
