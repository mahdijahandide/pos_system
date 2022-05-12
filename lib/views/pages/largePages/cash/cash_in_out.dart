import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/helper/app_color.dart';
import 'package:pos_system/views/components/buttons/custom_text_button.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/pages/largePages/modals/cash_modal.dart';

import '../../../components/texts/customText.dart';

class CashInOut extends StatelessWidget {
  const CashInOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,backgroundColor: Colors.grey.withOpacity(0.5),
          title: CustomText().createText(
              title: 'Cash in/out'.tr, size: 18, fontWeight: FontWeight.bold),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: IconButton(
                onPressed: () {
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
                            buttonText: 'Add Cash',
                            buttonColor: Colors.white,
                            textColor: Colors.black,
                            textSize: 17,
                            elevation: 6.0,
                            icon: const Icon(
                              Icons.add,
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
                            buttonText: 'Remove Cash',
                            buttonColor: Colors.white,
                            textSize: 17,
                            textColor: Colors.black,
                            elevation: 6.0,
                            icon: const Icon(
                              Icons.remove,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  CustomTextField().createTextField(hint: 'Amount', height: 50),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField()
                      .createTextField(hint: 'Description', height: 150),
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
      ),
    );
  }
}
