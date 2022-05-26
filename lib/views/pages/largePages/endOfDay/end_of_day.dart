import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:get/get.dart';
import 'package:input_calculator/input_calculator.dart';
import 'package:pos_system/services/controller/shift_controller.dart';
import 'package:pos_system/views/dialogs/shift_warning_dialog.dart';
import 'package:vk/vk.dart';

import '../../../components/buttons/custom_text_button.dart';
import '../../../components/textfields/textfield.dart';
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
                  ),
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
                            buttonText: 'End Shift',
                            buttonColor:controller.selectStartShift.value==false?Colors.teal: Colors.white,
                            textColor: controller.selectStartShift.value==false?Colors.white:Colors.black,
                            textSize: controller.selectStartShift.value==false?20:17,
                            elevation: 6.0,
                            icon: Icon(
                              Icons.money_off,color: controller.selectStartShift.value==false?Colors.white:Colors.black,
                              size: controller.selectStartShift.value==false?45:40,
                            ),
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
                            buttonText: 'Start Shift',
                            buttonColor: controller.selectStartShift.value==true?Colors.teal:Colors.white,
                            textSize: controller.selectStartShift.value==true?20:17,
                            textColor: controller.selectStartShift.value==true?Colors.white:Colors.black,
                            elevation: 6.0,
                            icon:  Icon(
                              Icons.money,color: controller.selectStartShift.value==true?Colors.white:Colors.black,
                              size: controller.selectStartShift.value==true?45:40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                      const SizedBox(height: 20,),

                      controller.selectStartShift.isTrue?
                            Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        child: Column(
                          children: [
                            CustomTextField().createTextField(
                                hint: 'cash starter value (optional)',
                                height: 50,keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: controller.valController,
                                onSubmitted: (_)async{
                                  Get.find<ShiftController>().startCashRequest(starterValue: controller.valController.text);
                                }
                            ),
                            Container(
                              color: const Color(0xffeeeeee),
                              child: VirtualKeyboard(
                                textColor: Colors.black,
                                type: VirtualKeyboardType.Numeric, textController: controller.valController,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            saveButton()
                          ],
                        ),
                      )
                          :Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                        CustomText().createSpaceKeyVal(
                            keyText: 'startCash', valText: '${controller.startCash
                            .value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'sellCash',
                            valText: '${controller.sellCash.value}',
                            valFontWeight: FontWeight.bold),
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
                            keyText: 'cashIn', valText: '${controller.cashIn
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
                            keyText: 'totalFunds', valText: '${controller.totalFunds
                            .value}', valFontWeight: FontWeight.bold),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText().createSpaceKeyVal(
                            keyText: 'totalRefund', valText: '${controller
                            .totalRefund.value}', valFontWeight: FontWeight.bold),
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
                            keyText: 'totalCashFunds', valText: '${controller.totalCashFunds
                            .value}', valFontWeight: FontWeight.bold),

                              const SizedBox(
                                height: 15,
                              ),
                              Row(children: [
                                SizedBox(width: 90,child: CustomText().createText(title: 'Cash Count: ')),
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xffdcdcdc)),
                                        color: Colors.white),
                                    child: CalculatorTextField(
                                      textAlign: TextAlign.end,
                                      operatorButtonColor: Colors.teal,
                                      title: 'Cash count',
                                      inputDecoration: const InputDecoration(hintText: 'enter cashCount (required)',border: InputBorder.none),
                                      //initialValue:0,
                                      //double.parse(controller.cashCount.value.text),
                                      onSubmitted: (value) {
                                        controller.cashCount.value.text=value.toString();
                                      },
                                    ),
                                  ),
                                ),
                                // IconButton(onPressed: (){
                                //   Get.defaultDialog(
                                //
                                //     content: CalculatorTextField(
                                //       initialValue: double.parse(controller.cashCount.value.text),
                                //       onSubmitted: (value) {
                                //         controller.cashCount.value.text=value.toString();
                                //       },
                                //     ),);
                                // }, icon: const Icon(Icons.calculate)),
                                // Expanded(child: CustomTextField().createTextField(hint: 'enter cashCount (required)', height: 40,controller: controller.cashCount.value,))
                              ],),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(children: [
                                SizedBox(width: 90,child: CustomText().createText(title: 'Card Count: ')),
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xffdcdcdc)),
                                        color: Colors.white),
                                    child: CalculatorTextField(
                                      textAlign: TextAlign.end,
                                      operatorButtonColor: Colors.teal,
                                      title: 'Card count',
                                      inputDecoration: const InputDecoration(hintText: 'enter cardCount (required)',border: InputBorder.none),
                                      //initialValue:0,
                                      //double.parse(controller.cardCount.value.text),
                                      onSubmitted: (value) {
                                        controller.cardCount.value.text=value.toString();
                                      },
                                    ),
                                  ),
                                ),
                                // IconButton(onPressed: (){
                                //   Get.defaultDialog(
                                //     content: CalculatorTextField(
                                //       initialValue: double.parse(controller.cardCount.value.text),
                                //       onSubmitted: (value) {
                                //         controller.cardCount.value.text=value.toString();
                                //       },
                                //     ),);
                                // }, icon: const Icon(Icons.calculate)),
                                // Expanded(child: CustomTextField().createTextField(hint: 'enter cardCount (required)', height: 40,controller: controller.cardCount.value,))
                              ],),
                              // const SizedBox(
                              //   height: 8,
                              // ),
                              // CustomText().createText(title: controller.cashCountStatusText.value,color: Colors.red),
                              // CustomText().createText(title: controller.cashCount.value.text!=(controller.sellCard.value-controller.refundCard.value).toString()?'card count does not match with system':'',color: Colors.red),
                              const SizedBox(
                                height: 15,
                              ),
                              saveButton()

                      ],)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  Widget saveButton(){
    return SizedBox(
        height: 50,
        width: Get.width / 2,
        child: CustomTextButton().createTextButton(
            buttonText: 'Save',
            buttonColor: Colors.teal,
            textColor: Colors.white,
            elevation: 6.0,
            onPress: (){
              if(controller.selectStartShift.isTrue){
                controller.startCashRequest(starterValue: controller.valController.text);
              }else{
                if(controller.cashCount.value.text.toString()==controller.totalCashFunds.value.toString()&&
                    controller.cardCount.value.text.toString()== (controller.sellCard.value-controller.refundCard.value).toString()){
                  controller.endCashRequest();
                }else if(controller.cashCount.value.text.toString()!=controller.totalCashFunds.value.toString()){
                  if(double.parse(controller.cashCount.value.text.toString())-double.parse(controller.totalCashFunds.value.toString())>0){
                    ShiftWarningDialog.showCustomDialog(title: 'warning', msg: 'Your account balance is ${double.parse(controller.cashCount.value.text.toString())-double.parse(controller.totalCashFunds.value.toString())} more than your sales in cash count');
                  }else if(double.parse(controller.cashCount.value.text.toString())-double.parse(controller.totalCashFunds.value.toString())<0){
                    ShiftWarningDialog.showCustomDialog(title: 'danger', msg: 'You have less than ${(double.parse(controller.cashCount.value.text.toString())-double.parse(controller.totalCashFunds.value.toString()))} in cash count');
                  }
                }else if(controller.cardCount.value.text.toString()!= (controller.sellCard.value-controller.refundCard.value).toString()){
                  if(double.parse(controller.cardCount.value.text.toString())-(controller.sellCard.value-controller.refundCard.value)>0){
                    ShiftWarningDialog.showCustomDialog(title: 'warning', msg: 'Your account balance is ${double.parse(controller.cardCount.value.text.toString())-(controller.sellCard.value-controller.refundCard.value)} more than your sales in card count');
                  }else if(double.parse(controller.cardCount.value.text.toString())-(controller.sellCard.value-controller.refundCard.value)<0){
                    ShiftWarningDialog.showCustomDialog(title: 'danger', msg: 'You have less than ${double.parse(controller.cardCount.value.text.toString())-(controller.sellCard.value-controller.refundCard.value)} in card count');
                  }
                }
              }
            }
        ));
  }
}
