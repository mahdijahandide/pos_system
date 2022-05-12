import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/views/components/buttons/custom_text_button.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class CheckoutModal extends StatelessWidget {
  String title;

  CheckoutModal({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<CustomerController>().selectedCustomer != null) {
      Get.find<CustomerController>().customerNameController.text =
          Get.find<CustomerController>().selectedCustomer.name ?? '';
      Get.find<CustomerController>().customerEmailController.text =
          Get.find<CustomerController>().selectedCustomer.email ?? '';
      Get.find<CustomerController>().customerNumberController.text =
          Get.find<CustomerController>().selectedCustomer.mobile ?? '';
    } else {
      Get.find<CustomerController>().customerNameController.text = '';
      Get.find<CustomerController>().customerEmailController.text = '';
      Get.find<CustomerController>().customerNumberController.text = '';
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.only(top: 80),
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    CustomText().createText(color: Colors.black,
                        title: title, size: 18, fontWeight: FontWeight.bold),
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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 38,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CustomText().createText(title: 'Customer Name: ')),
                        Expanded(
                            flex: 9,
                            child: CustomTextField().createTextField(
                              hint: 'enter name',
                              height: 50,
                              controller: Get.find<CustomerController>()
                                  .customerNameController,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child:
                                CustomText().createText(title: 'Customer Email: ')),
                        Expanded(
                            flex: 9,
                            child: CustomTextField().createTextField(
                                hint: 'enter email',
                                height: 50,
                                controller: Get.find<CustomerController>()
                                    .customerEmailController)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child:
                                CustomText().createText(title: 'Customer Mobile: ')),
                        Expanded(
                            flex: 9,
                            child: CustomTextField().createTextField(
                                hint: 'enter number',
                                height: 50,
                                controller: Get.find<CustomerController>()
                                    .customerNumberController)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CustomText().createText(title: 'Total Amount: ')),
                        Expanded(
                          flex: 9,
                          child: CustomText().createText(
                              title: (Get.find<CartController>().totalAmount +
                                      Get.find<CartController>().discountAmount +
                                      Get.find<CartController>().deliveryAmount)
                                  .toString(),
                              size: 26,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Column(
                        children: [

                          Expanded(
                            child: Container(
                              width: Get.width/1.5,
                              color: Colors.white,
                              child: SimpleCalculator(
                                value: 0.0,
                                hideExpression: true,
                                onChanged: (key, value, expression) {
                                  /*...*/
                                },
                                theme: const CalculatorThemeData(
                                  displayColor: Colors.white,
                                  displayStyle: TextStyle(fontSize: 80, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 60,
                          //   width: 190,
                          //   child: CustomTextButton().createTextButton(
                          //       onPress: () {
                          //         Get.toNamed('/print');
                          //       },
                          //       buttonText: 'Print',
                          //       buttonColor: Colors.pink,
                          //       textColor: Colors.white,
                          //       icon: const Icon(
                          //         Icons.print,
                          //         color: Colors.white,
                          //       )),
                          // ),
                          SizedBox(
                            height: 65.0,
                            width: Get.width/1.5,
                            child: CustomTextButton().createTextButton(
                                onPress: () {
                                  Get.find<CartController>().checkoutCart();
                                },
                                buttonText: 'Accept payment',borderRadius: 0.0,
                                buttonColor: Colors.teal,
                                textColor: Colors.white,
                                icon: const Icon(
                                  Icons.payment,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
