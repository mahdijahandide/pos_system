import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cash_controller.dart';
import 'package:pos_system/views/components/buttons/custom_text_button.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/pages/largePages/modals/cash_modal.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../../components/texts/customText.dart';

class CashInOut extends GetView<CashController> {
  const CashInOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.offNamed('/dashboard', preventDuplicates: false);
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.grey.withOpacity(0.5),
            title: CustomText().createText(
                title: 'Cash In/Out'.tr, size: 18, fontWeight: FontWeight.bold),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: IconButton(
                  onPressed: () {
                    controller.hasHistoryList.value = false;
                    Get.bottomSheet(
                      CashModal(title: 'Cash History'),
                      isScrollControlled: true,
                      enableDrag: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                ),
              )
            ],
          ),
          body: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Container(
                  width: 600,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 1))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              child: CustomTextButton().createTextButton(
                                  buttonText: 'Add Cash',
                                  buttonColor: controller.isAddCash.isTrue
                                      ? Colors.teal
                                      : Colors.white,
                                  textColor: controller.isAddCash.isTrue
                                      ? Colors.white
                                      : Colors.black,
                                  textSize:
                                      controller.isAddCash.isTrue ? 20 : 17,
                                  elevation: 6.0,
                                  icon: Icon(
                                    Icons.add,
                                    color: controller.isAddCash.isTrue
                                        ? Colors.white
                                        : Colors.black,
                                    size: controller.isAddCash.isTrue ? 45 : 40,
                                  ),
                                  onPress: () {
                                    controller.isAddCash.value = true;
                                  }),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              child: CustomTextButton().createTextButton(
                                  buttonText: 'Remove Cash',
                                  buttonColor: controller.isAddCash.isFalse
                                      ? Colors.teal
                                      : Colors.white,
                                  textSize:
                                      controller.isAddCash.isFalse ? 20 : 17,
                                  textColor: controller.isAddCash.isFalse
                                      ? Colors.white
                                      : Colors.black,
                                  elevation: 6.0,
                                  icon: Icon(
                                    Icons.remove,
                                    color: controller.isAddCash.isFalse
                                        ? Colors.white
                                        : Colors.black,
                                    size:
                                        controller.isAddCash.isFalse ? 45 : 40,
                                  ),
                                  onPress: () {
                                    controller.isAddCash.value = false;
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      CustomTextField().createTextField(
                          hint: 'Amount',
                          height: 50,
                          onTap: () {
                            controller.descriptionActive.value = false;

                            Timer(const Duration(milliseconds: 200), () {
                              controller.amountActive.value =
                                  !controller.amountActive.value;
                            });
                          },
                          hasSuffixIcon: true,
                          suffixIcon: Icons.keyboard,
                          suffixPress: () {
                            controller.amountActive.value =
                                !controller.amountActive.value;
                          },
                          controller: controller.amountTextController),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField().createTextField(
                          hint: 'Description',
                          height: 150,
                          onTap: () {
                            controller.amountActive.value = false;

                            Timer(const Duration(milliseconds: 200), () {
                              controller.descriptionActive.value =
                                  !controller.descriptionActive.value;
                            });
                          },
                          suffixIcon: Icons.keyboard,
                          hasSuffixIcon: true,
                          suffixPress: () {
                            controller.descriptionActive.value =
                                !controller.descriptionActive.value;
                          },
                          maxLines: 6,
                          controller: controller.descriptionTextController),
                      const Expanded(child: SizedBox()),
                      SizedBox(
                          height: 50,
                          width: Get.width / 2,
                          child: CustomTextButton().createTextButton(
                              onPress: () {
                                if (controller
                                        .amountTextController.text.isNotEmpty &&
                                    int.parse(controller
                                            .amountTextController.text
                                            .toString()) >
                                        0) {
                                  controller.addOrRemoveCashRequest();
                                } else {
                                  Snack().createSnack(
                                      title: 'Warning',
                                      msg: 'Please Enter Right Value',
                                      bgColor: Colors.yellow,
                                      msgColor: Colors.black,
                                      titleColor: Colors.black);
                                }
                              },
                              buttonText: 'Save',
                              buttonColor: Colors.teal,
                              textColor: Colors.white,
                              elevation: 6.0))
                    ],
                  ),
                ),
              ),
            );
          }),
          bottomNavigationBar: Obx(
            () => Get.find<CashController>().amountActive.isTrue
                ? Container(
                    height: 350,
                    color: const Color(0xffeeeeee),
                    child: VirtualKeyboard(
                        textColor: Colors.black,
                        focusNode: FocusNode(),
                        type: VirtualKeyboardType.Alphanumeric,
                        textController:
                            Get.find<CashController>().amountTextController),
                  )
                : Get.find<CashController>().descriptionActive.isTrue
                    ? Container(
                        height: 350,
                        color: const Color(0xffeeeeee),
                        child: VirtualKeyboard(
                            textColor: Colors.black,
                            focusNode: FocusNode(),
                            type: VirtualKeyboardType.Alphanumeric,
                            textController: Get.find<CashController>()
                                .descriptionTextController),
                      )
                    : const SizedBox(),
          )),
    );
  }
}
