import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/views/components/buttons/custom_text_button.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:vk/vk.dart';

import '../../../../helper/autocomplete_helper.dart';
import '../customer/add_customer_modal.dart';

class CheckoutModal extends GetView<CartController> {
  String title;

  CheckoutModal({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<CustomerController>().hasCustomer.isFalse) {
      Get.find<CustomerController>()
          .getCustomers(doInBackground: true, hasLoading: false);
    }
    TextEditingController searchController = TextEditingController();
    if (Get.find<CustomerController>().selectedCustomer != null) {
      Get.find<CustomerController>().customerNameController.text =
          Get.find<CustomerController>().selectedCustomer.name ?? '';
      Get.find<CustomerController>().searchController.text =
          Get.find<CustomerController>().selectedCustomer.name ?? '';
      Get.find<CustomerController>().customerEmailController.text =
          Get.find<CustomerController>().selectedCustomer.email ?? '';
      Get.find<CustomerController>().customerNumberController.text =
          Get.find<CustomerController>().selectedCustomer.mobile ?? '';
      searchController.text =
          Get.find<CustomerController>().selectedCustomer.name ?? '';
    } else {
      searchController.text = '';
      Get.find<CustomerController>().customerNameController.text = '';
      Get.find<CustomerController>().customerEmailController.text = '';
      Get.find<CustomerController>().customerNumberController.text = '';
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  CustomText().createText(
                      color: Colors.black,
                      title: title,
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 38,
                  ),
                  Obx(
                    () => Get.find<CustomerController>().hasCustomer.isFalse
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            children: [
                              CustomText().createText(title: 'Customer Name: '),
                              const SizedBox(
                                width: 12,
                              ),
                              PopupMenuButton(
                                  icon: const Icon(Icons.info),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry>[
                                        PopupMenuItem(
                                          child: ListTile(
                                              onTap: () {},
                                              leading: const Icon(
                                                Icons.mail,
                                                color: Colors.black,
                                              ),
                                              title: Text(
                                                Get.find<CustomerController>()
                                                    .selectedCustomer
                                                    .email,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )),
                                        ),
                                        PopupMenuItem(
                                          child: ListTile(
                                              onTap: () {},
                                              leading: const Icon(
                                                Icons.phone,
                                                color: Colors.black,
                                              ),
                                              title: Text(
                                                Get.find<CustomerController>()
                                                    .selectedCustomer
                                                    .mobile,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )),
                                        ),
                                      ]),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                flex: 9,
                                child: TextFieldSearch(
                                  hasKeyboard: true,
                                  initialList: Get.find<CustomerController>()
                                      .customerName,
                                  label: 'Customer Name/No',
                                  controller: searchController,
                                  getSelectedValue: (selected) {
                                    Get.find<CustomerController>()
                                            .selectedCustomer =
                                        Get.find<CustomerController>()
                                            .customerList
                                            .where((element) =>
                                                element.name == selected)
                                            .first;

                                    if (Get.find<CustomerController>()
                                            .selectedCustomer !=
                                        null) {
                                      Get.find<CustomerController>()
                                          .customerNameController
                                          .text = Get.find<CustomerController>()
                                              .selectedCustomer
                                              .name ??
                                          '';
                                      Get.find<CustomerController>()
                                          .customerEmailController
                                          .text = Get.find<CustomerController>()
                                              .selectedCustomer
                                              .email ??
                                          '';
                                      Get.find<CustomerController>()
                                          .customerNumberController
                                          .text = Get.find<CustomerController>()
                                              .selectedCustomer
                                              .mobile ??
                                          '';
                                    } else {
                                      Get.find<CustomerController>()
                                          .customerNameController
                                          .text = '';
                                      Get.find<CustomerController>()
                                          .customerEmailController
                                          .text = '';
                                      Get.find<CustomerController>()
                                          .customerNumberController
                                          .text = '';
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              SizedBox(
                                width: 120,
                                height: 60,
                                child: CustomTextButton().createTextButton(
                                    buttonText: 'Create',
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    buttonColor: Colors.teal,
                                    textColor: Colors.white,
                                    onPress: () {
                                      Get.bottomSheet(
                                          AddCustomerModal().createModal());
                                    }),
                              )
                            ],
                          ),
                  ),

                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: CustomText()
                  //             .createText(title: 'Customer Email: ')),
                  //     Expanded(
                  //         flex: 9,
                  //         child: CustomTextField().createTextField(
                  //             hint: 'enter email',
                  //             height: 50,
                  //             controller: Get.find<CustomerController>()
                  //                 .customerEmailController)),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: CustomText()
                  //             .createText(title: 'Customer Mobile: ')),
                  //     Expanded(
                  //         flex: 9,
                  //         child: CustomTextField().createTextField(
                  //             hint: 'enter number',
                  //             height: 50,
                  //             controller: Get.find<CustomerController>()
                  //                 .customerNumberController)),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(() {
                    return Row(
                      children: [
                        CustomText().createText(
                            title: 'Total Amount: ',
                            size: 24,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          width: 200,
                          child: CustomText().createText(
                              title: (controller.totalAmount -
                                      controller.discountAmount +
                                      controller.deliveryAmount)
                                  .toStringAsFixed(3),
                              size: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomText().createText(
                            title: controller.balanceStatus.value == ''
                                ? ''
                                : controller.balanceStatus.value,
                            size: 18,
                            fontWeight: FontWeight.bold,
                            color: controller.calController.text == ''
                                ? Colors.white
                                : double.parse(controller.calController.text
                                                .toString()) -
                                            double.parse((controller
                                                        .totalAmount +
                                                    controller.discountAmount +
                                                    controller.deliveryAmount)
                                                .toString()) <
                                        0
                                    ? Colors.green
                                    : Colors.red),
                        const Expanded(child: SizedBox())
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:
                                Get.width > 600 ? Get.width / 3 : Get.width / 2,
                            child: CustomTextField().createTextField(
                                hint: 'customer paid',
                                height: 50,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      (RegExp("[0-9.]")))
                                ],
                                controller: controller.calController,
                                onSubmitted: (_) async {
                                  String total = (controller.totalAmount -
                                          controller.discountAmount +
                                          controller.deliveryAmount)
                                      .toString();
                                  if (controller.calController.text == total) {
                                    controller.checkoutCart();
                                  } else if (double.parse(controller
                                              .calController.text
                                              .toString()) -
                                          double.parse(total) >
                                      0) {
                                    controller.checkoutCart();
                                    controller.balanceStatus.value =
                                        'Change: ${double.parse(controller.calController.text.toString()) - double.parse(total.toString())}';
                                  } else if (double.parse(controller
                                              .calController.text
                                              .toString()) -
                                          double.parse(total) <
                                      0) {
                                    controller.balanceStatus.value =
                                        'Balance: ${double.parse(controller.calController.text.toString()) - double.parse(total)}';
                                  }
                                }),
                          ),
                          Container(
                            width:
                                Get.width > 600 ? Get.width / 3 : Get.width / 2,
                            color: const Color(0xffeeeeee),
                            child: VirtualKeyboard(
                              textColor: Colors.black,
                              type: VirtualKeyboardType.Numeric,
                              textController: controller.calController,
                            ),
                          ),
                          SizedBox(
                            height: 65.0,
                            width:
                                Get.width > 600 ? Get.width / 3 : Get.width / 2,
                            child: CustomTextButton().createTextButton(
                                onPress: () {
                                  String total = (controller.totalAmount -
                                          controller.discountAmount +
                                          controller.deliveryAmount)
                                      .toString();
                                  if (double.parse(
                                              controller.calController.text)
                                          .toStringAsFixed(3) ==
                                      double.parse(total).toStringAsFixed(3)) {
                                    controller.checkoutCart();
                                  } else if (double.parse(controller
                                              .calController.text
                                              .toString()) -
                                          double.parse(total) >
                                      0) {
                                    controller.checkoutCart();
                                    controller.balanceStatus.value =
                                        'Change: ${double.parse(controller.calController.text.toString()) - double.parse(total)}';
                                  } else if (double.parse(controller
                                              .calController.text
                                              .toString()) -
                                          double.parse(total) <
                                      0) {
                                    controller.balanceStatus.value =
                                        'Balance: ${double.parse(controller.calController.text.toString()) - double.parse(total)}';
                                  }
                                },
                                buttonText: 'Accept payment',
                                borderRadius: 0.0,
                                buttonColor: Colors.teal,
                                textColor: Colors.white,
                                icon: const Icon(
                                  Icons.payment,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Obx(() {
                        return Column(
                          children: [
                            paymentTypeOption(
                                'Card',
                                'PCARD',
                                Icon(
                                  Icons.credit_card,
                                  color: controller.selectedPaymentType.value ==
                                          'PCARD'
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            paymentTypeOption(
                                'Cash',
                                'PCOD',
                                Icon(
                                  Icons.monetization_on,
                                  color: controller.selectedPaymentType.value ==
                                          'PCOD'
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            paymentTypeOption(
                                'Knet',
                                'PKNET',
                                Icon(
                                  Icons.attach_money_rounded,
                                  color: controller.selectedPaymentType.value ==
                                          'PKNET'
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            paymentTypeOption(
                                'Visa',
                                'PVISA',
                                Icon(
                                  Icons.money_rounded,
                                  color: controller.selectedPaymentType.value ==
                                          'PVISA'
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          ],
                        );
                      })
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget paymentTypeOption(String title, String type, Icon ic) {
    return SizedBox(
      height: 80,
      width: 120,
      child: CustomTextButton().createTextButton(
          buttonText: title,
          buttonColor: controller.selectedPaymentType.value == type
              ? Colors.teal
              : Colors.white,
          textSize: controller.selectedPaymentType.value == type ? 20 : 17,
          textColor: controller.selectedPaymentType.value == type
              ? Colors.white
              : Colors.black,
          elevation: 6.0,
          icon: ic,
          onPress: () {
            controller.selectedPaymentType.value = type;
          }),
    );
  }
}
