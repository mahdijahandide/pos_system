import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

class PasswordDialog {
  static final PasswordDialog _instance = PasswordDialog.internal();

  PasswordDialog.internal();

  factory PasswordDialog() => _instance;

  static void showCustomDialog({required title}) {
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (CartController controller) {
        controller.passwordTxtController.text = '';

        return Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            children: [
              CustomTextField().createTextField(
                  autoFocus: true,
                  hint: 'Enter Password',
                  height: 50,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controller.passwordTxtController,
                  onSubmitted: (_) async {
                    if (controller.passwordTxtController.text.isNotEmpty) {
                      Get.back();
                      controller.checkAdminPassword(
                          pass: controller.passwordTxtController.text);
                    } else {
                      Snack().createSnack(
                          title: 'Warning',
                          msg: 'Enter Password',
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
                  textController: controller.passwordTxtController,
                  focusNode: FocusNode(),
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
              .passwordTxtController
              .text
              .isNotEmpty) {
            Get.back();
            Get.find<CartController>().checkAdminPassword(
                pass: Get.find<CartController>().passwordTxtController.text);
          } else {
            Snack().createSnack(
                title: 'Warning',
                msg: 'Enter Password',
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
