import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/views/components/buttons/custom_text_button.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:vk/vk.dart';

import '../../../../services/controller/product_controller.dart';

class RefundModal extends GetView<CartController> {
  String title;
  String total;
  bool isWholeCart;

  RefundModal(
      {Key? key,
      required this.title,
      required this.total,
      required this.isWholeCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProductController>().overlaysCounter.value++;
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
                  Obx(() {
                    return Row(
                      children: [
                        CustomText().createText(
                            title: 'Total Amount: ',
                            fontWeight: FontWeight.bold,
                            size: 26),
                        SizedBox(
                          width: 200,
                          child: CustomText().createText(
                              title: double.parse(total).toStringAsFixed(3),
                              size: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomText().createText(
                            title: controller.balanceStatus.value == ''
                                ? ''
                                : double.parse(controller.balanceStatus.value
                                        .toString())
                                    .toStringAsFixed(3),
                            size: 18,
                            fontWeight: FontWeight.bold,
                            color: controller.balanceStatus.value == ''
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:
                                Get.width > 600 ? Get.width / 3 : Get.width / 2,
                            child: CustomTextField().createTextField(
                                hint: 'cashier paid',
                                height: 50,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      (RegExp("[0-9.]")))
                                ],
                                controller: controller.calController,
                                onSubmitted: (_) async {
                                  refundCalculation();
                                }),
                          ),
                          Container(
                            width:
                                Get.width > 600 ? Get.width / 3 : Get.width / 2,
                            color: const Color(0xffeeeeee),
                            child: VirtualKeyboard(
                              focusNode: FocusNode(),
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
                                  refundCalculation();
                                },
                                buttonText: 'Accept Refund',
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

  void refundCalculation() {
    String total = isWholeCart == true
        ? controller.refundCartTotalPrice
        : (controller.totalAmount - controller.discountAmount).toString();

    if (double.parse(controller.calController.text).toStringAsFixed(3) ==
        double.parse(total).toStringAsFixed(3)) {
      isWholeCart == true
          ? controller.refundCartRequest()
          : controller.refundCartItemRequest();
    } else if (double.parse(controller.calController.text.toString()) -
            double.parse(total) >
        0) {
      isWholeCart == true
          ? controller.refundCartRequest()
          : controller.refundCartItemRequest();
      controller.balanceStatus.value =
          'Change: ${double.parse(controller.calController.text.toString()) - double.parse(total)}';
    } else if (double.parse(controller.calController.text.toString()) -
            double.parse(total) <
        0) {
      controller.balanceStatus.value =
          'Balance: ${double.parse(controller.calController.text.toString()) - double.parse(total)}';
    }
  }
}
