import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:printing/printing.dart';

import '../../../components/buttons/custom_text_button.dart';
import '../../../components/texts/customText.dart';

class SuccessModal extends GetView<CartController> {
  const SuccessModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          Container(
            width: Get.width,
            color: Colors.grey.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                CustomText().createText(
                    title: 'Success',
                    size: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 23,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on),
              CustomText().createText(
                  title: controller.balanceStatus.value == ''
                      ? 'change: 0.0'
                      : controller.balanceStatus.value,
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: Colors.green),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          CustomText().createText(
              title: 'How would the customer like their receipt? ', size: 25),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 250,
                height: 150,
                child: CustomTextButton().createTextButton(
                    buttonText: 'Print',
                    buttonColor: Colors.white,
                    elevation: 6,
                    textColor: Colors.black,
                    icon: const Icon(Icons.print),
                    onPress: () async {
                      Get.back();
                      await Printing.layoutPdf(
                          onLayout: (_) => controller.generatePdf());
                    }),
              ),
              SizedBox(
                width: 250,
                height: 150,
                child: CustomTextButton().createTextButton(
                    buttonText: 'Save',
                    buttonColor: Colors.white,
                    elevation: 6,
                    textColor: Colors.black,
                    icon: const Icon(Icons.save),
                    onPress: () async {
                      //Get.back();
                    }),
              ),
              SizedBox(
                width: 250,
                height: 150,
                child: CustomTextButton().createTextButton(
                    buttonText: 'Email',
                    buttonColor: Colors.white,
                    elevation: 6,
                    textColor: Colors.black,
                    icon: const Icon(Icons.mail),
                    onPress: () async {
                      // Get.back();
                      // await Printing.layoutPdf(onLayout: (_) => generatePdf());
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
