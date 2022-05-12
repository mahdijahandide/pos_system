import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:get/get.dart';

import '../../../components/buttons/custom_text_button.dart';
import '../../../components/texts/customText.dart';


class EndOfDay extends StatelessWidget {
  const EndOfDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: 'EndOfDay'.tr, size: 18, fontWeight: FontWeight.bold),
        actions:[Padding(padding: const EdgeInsets.symmetric(horizontal: 12),child: IconButton(onPressed: (){

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
                    displayStyle: TextStyle(fontSize: 80, color: Colors.black),
                  ),
                ),
              )
          );

        }, icon: const Icon(Icons.calculate)),)],
      ),
      body: Padding(
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
                          buttonColor: Colors.white,
                          textColor: Colors.black,
                          textSize: 17,
                          elevation: 6.0,
                          icon: const Icon(
                            Icons.person,
                            size: 40,
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
                          buttonText: 'Start Cash',
                          buttonColor: Colors.white,
                          textSize: 17,
                          textColor: Colors.black,
                          elevation: 6.0,
                          icon: const Icon(
                            Icons.start,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                CustomText().createSpaceKeyVal(keyText: 'Cash', valText: '500 Kd',valFontWeight: FontWeight.bold),
                const SizedBox(
                  height: 15,
                ),
                CustomText().createSpaceKeyVal(keyText: 'Credit', valText: '1000 Kd',valFontWeight: FontWeight.bold),
                const Divider(),
                CustomText().createSpaceKeyVal(keyText: 'Total Amount', valText: '1500 Kd',valFontWeight: FontWeight.bold),
                const Expanded(child: SizedBox()),
                SizedBox(
                    height: 50,
                    width: Get.width / 2,
                    child: CustomTextButton().createTextButton(
                        buttonText: 'Save',
                        buttonColor: Colors.teal,
                        textColor: Colors.white,
                        elevation: 6.0))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
