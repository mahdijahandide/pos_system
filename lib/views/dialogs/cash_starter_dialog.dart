import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/controller/shift_controller.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

class CashStarterDialog {
  static final CashStarterDialog _instance = CashStarterDialog.internal();

  CashStarterDialog.internal();

  factory CashStarterDialog() => _instance;

  static void showCustomDialog({required title}) {
    TextEditingController valController = TextEditingController();
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            children: [
              CustomTextField().createTextField(
                  hint: 'cash starter value (optional)',
                  height: 50,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: valController,
                  onSubmitted: (_) async {
                    Get.find<ShiftController>()
                        .startCashRequest(starterValue: valController.text);
                  }),
              Container(
                color: const Color(0xffeeeeee),
                child: VirtualKeyboard(
                  textColor: Colors.black,
                  type: VirtualKeyboardType.Numeric,
                  textController: valController,
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
          Get.find<ShiftController>()
              .startCashRequest(starterValue: valController.text);
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
