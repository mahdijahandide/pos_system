import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../../components/buttons/custom_text_button.dart';
import '../../../components/textfields/textfield.dart';
import '../../../components/texts/customText.dart';

class AddCustomerModal {
  FocusNode name = FocusNode();
  FocusNode number = FocusNode();
  FocusNode email = FocusNode();

  Widget createModal() {
    return Container(
        color: Colors.white,
        //padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return Stack(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    CustomText().createText(
                        title: 'Add Customer',
                        size: 18,
                        fontWeight: FontWeight.bold),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 23,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox()),
                    CustomTextField().createTextField(
                        node: name,
                        hint: 'Name',
                        onTap: () {
                          Get
                              .find<CustomerController>()
                              .focusName
                              .value = true;
                          Get
                              .find<CustomerController>()
                              .focusNumber
                              .value =
                          false;
                          Get
                              .find<CustomerController>()
                              .focusEmail
                              .value =
                          false;
                        },
                        height: 50,
                        controller: Get
                            .find<CustomerController>()
                            .addCustomerNameController),
                    const SizedBox(
                      height: 8.0,
                    ),
                    CustomTextField().createTextField(
                        hint: 'Mobile',
                        node: number,
                        onTap: () {
                          Get
                              .find<CustomerController>()
                              .focusNumber
                              .value =
                          true;
                          Get
                              .find<CustomerController>()
                              .focusName
                              .value =
                          false;
                          Get
                              .find<CustomerController>()
                              .focusEmail
                              .value =
                          false;
                        },
                        height: 50,
                        controller: Get
                            .find<CustomerController>()
                            .addCustomerNumberController),
                    const SizedBox(
                      height: 8.0,
                    ),
                    CustomTextField().createTextField(
                        hint: 'Email',
                        node: email,
                        onTap: () {
                          Get
                              .find<CustomerController>()
                              .focusEmail
                              .value =
                          true;
                          Get
                              .find<CustomerController>()
                              .focusNumber
                              .value =
                          false;
                          Get
                              .find<CustomerController>()
                              .focusName
                              .value =
                          false;
                        },
                        height: 50,
                        controller: Get
                            .find<CustomerController>()
                            .addCustomerEmailController),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                        width: 150,
                        height: 60,
                        child: CustomTextButton().createTextButton(
                            onPress: () {
                              if (Get
                                  .find<CustomerController>()
                                  .addCustomerNameController
                                  .text
                                  .isNotEmpty &&
                                  Get
                                      .find<CustomerController>()
                                      .addCustomerNumberController
                                      .text
                                      .isNotEmpty) {
                                Get.find<CustomerController>()
                                    .addCustomerRequest();
                              } else {
                                Snack().createSnack(
                                    title: 'Warning',
                                    msg: 'Please Fill The Form',
                                    bgColor: Colors.yellow,
                                    msgColor: Colors.black,
                                    titleColor: Colors.black);
                              }
                            },
                            elevation: 6,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            buttonText: 'Add',
                            buttonColor: Colors.teal,
                            textColor: Colors.white)),
                    const SizedBox(
                      height: 15.0,
                    ),
                    createNameKeyboard(),
                    createNumberKeyboard(),
                    createEmailKeyboard()
                  ],
                ),
              ),
            ],
          );
        }));
  }

  Widget createNameKeyboard() {
    if (Get
        .find<CustomerController>()
        .focusName
        .isTrue) {
      return Container(
        height: 350,
        color: const Color(0xffeeeeee),
        child: VirtualKeyboard(
          textColor: Colors.black,
          type: VirtualKeyboardType.Alphanumeric,
          textController:
          Get
              .find<CustomerController>()
              .addCustomerNameController,
          // focusNode: name,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createNumberKeyboard() {
    if (Get
        .find<CustomerController>()
        .focusNumber
        .isTrue) {
      return Container(
        height: 350,
        color: const Color(0xffeeeeee),
        child: VirtualKeyboard(
          textColor: Colors.black,
          type: VirtualKeyboardType.Alphanumeric,
          textController:
          Get
              .find<CustomerController>()
              .addCustomerNumberController,
          // focusNode: number,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createEmailKeyboard() {
    if (Get
        .find<CustomerController>()
        .focusEmail
        .isTrue) {
      return Container(height: 350,
        color: const Color(0xffeeeeee),
        child: VirtualKeyboard(
          textColor: Colors.black,
          type: VirtualKeyboardType.Alphanumeric,
          textController:
          Get
              .find<CustomerController>()
              .addCustomerEmailController,
          // focusNode: email,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

}
