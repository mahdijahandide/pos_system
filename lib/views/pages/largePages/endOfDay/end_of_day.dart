import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/shift_controller.dart';
import 'package:pos_system/views/dialogs/cash_starter_dialog.dart';

import '../../../components/buttons/custom_text_button.dart';
import '../../../components/texts/customText.dart';


class EndOfDay extends GetView<ShiftController> {
  const EndOfDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ShiftController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: 'EndOfDay'.tr, size: 18, fontWeight: FontWeight.bold),
        actions: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(onPressed: () {
              Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: SimpleCalculator(
                      value: 0.0,
                      hideExpression: true,
                      onChanged: (key, value, expression) {
                        /*...*/
                      },
                      theme: const CalculatorThemeData(
                        displayColor: Colors.white,
                        displayStyle: TextStyle(
                            fontSize: 80, color: Colors.black),
                      ),
                    ),
                  )
              );
            }, icon: const Icon(Icons.calculate)),)
        ],
      ),
      body: Obx(() {
        return controller.showLoading.isTrue?const Center(child: CircularProgressIndicator(),): Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                            buttonText: 'Cash out',
                            buttonColor:controller.selectStartShift.value==false?Colors.teal: Colors.white,
                            textColor: controller.selectStartShift.value==false?Colors.white:Colors.black,
                            textSize: controller.selectStartShift.value==false?20:17,
                            elevation: 6.0,
                            icon: Icon(
                              Icons.money_off,color: controller.selectStartShift.value==false?Colors.white:Colors.black,
                              size: controller.selectStartShift.value==false?45:40,
                            ),
                            onPress: (){
                              controller.selectStartShift.value=false;
                            }
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: CustomTextButton().createTextButton(
                            buttonText: 'Start Cash',
                            buttonColor: controller.selectStartShift.value==true?Colors.teal:Colors.white,
                            textSize: controller.selectStartShift.value==true?20:17,
                            textColor: controller.selectStartShift.value==true?Colors.white:Colors.black,
                            elevation: 6.0,
                            icon:  Icon(
                              Icons.money,color: controller.selectStartShift.value==true?Colors.white:Colors.black,
                              size: controller.selectStartShift.value==true?45:40,
                            ),
                            onPress: (){
                              controller.selectStartShift.value=true;
                            }
                          ),
                        ),
                      ),
                    ],
                  ),

                      const SizedBox(height: 20,),

                      Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                        CustomText().createSpaceKeyVal(
                            keyText: 'existCash', valText: '${controller.existCash
                            .value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'shouldExistCash',
                            valText: '${controller.shouldExistCash.value}',
                            valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'startCash', valText: '${controller.startCash
                            .value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'sellCash', valText: '${controller.sellCash
                            .value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'sellCard', valText: '${controller.sellCard
                            .value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'totalSell', valText: '${controller.totalSell
                            .value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'refundCash', valText: '${controller
                            .refundCash.value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'refundCard', valText: '${controller
                            .refundCard.value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'totalRefund', valText: '${controller
                            .totalRefund.value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),

                        const Divider(),
                        CustomText().createSpaceKeyVal(
                            keyText: 'Total Amount', valText: '${controller.total
                            .value}', valFontWeight: FontWeight.bold),



                      ],)),

                  const Expanded(child: SizedBox()),

                  SizedBox(
                      height: 50,
                      width: Get.width / 2,
                      child: CustomTextButton().createTextButton(
                          buttonText: 'Save',
                          buttonColor: Colors.teal,
                          textColor: Colors.white,
                          elevation: 6.0,
                          onPress: (){
                              if(controller.selectStartShift.isTrue){
                                  CashStarterDialog.showCustomDialog(title: 'starter Value');
                              }else{
                                  controller.endCashRequest();
                              }
                          }
                      ))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
