import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:vk/vk.dart';

class DesktopLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(
              image: const AssetImage(
                'assets/images/png/logo.png',
              ),
              width: Get.width < 1010.0 ? 150.0 : 400.0,
              height: Get.height < 1010.0 ? 150.0 : 400.0,
            ),
            CustomText().createText(
                title: 'aronium'.tr, fontWeight: FontWeight.bold, size: 15),
            const SizedBox(
              height: 40,
            ),
            CustomText().createText(
                title: 'login'.tr, fontWeight: FontWeight.normal, size: 22),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 600,
                child: CustomTextField().createTextField(
                    hint: '',
                    height: 45.0,
                    controller:
                        Get.find<AuthController>().loginControllerUserText,
                    borderColor: Colors.blue,
                    align: TextAlign.start,
                    hasSuffixIcon: false,
                    hasPrefixIcon: true,
                    node: Get.find<AuthController>().userFocus,
                    prefixIcon: Icons.person)),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 600,
              child: CustomTextField().createTextField(
                  hint: '',
                  height: 45.0,
                  node: Get.find<AuthController>().passwordFocus,
                  controller:
                      Get.find<AuthController>().loginControllerPasswordText,
                  borderColor: Colors.blue,
                  obscure: true,
                  align: TextAlign.start,
                  hasSuffixIcon: true,
                  hasPrefixIcon: true,
                  prefixIcon: Icons.lock,
                  suffixIcon: Icons.arrow_forward,
                  suffixPress: () {
                    Get.find<AuthController>().loginRequest();
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomText().createText(
                title: 'forgot_password'.tr,
                fontWeight: FontWeight.normal,
                size: 16,
                color: Colors.blue),
            const Expanded(child: SizedBox()),
            Container(
              color: const Color(0xffeeeeee),
              child: VirtualKeyboard(
                  textColor: Colors.black,
                  type: Get.find<AuthController>().isNumericMode
                      ? VirtualKeyboardType.Numeric
                      : VirtualKeyboardType.Alphanumeric,
                  textController:
                      Get.find<AuthController>().userFocus.hasPrimaryFocus==true
                          ? Get.find<AuthController>().loginControllerUserText
                          : Get.find<AuthController>().loginControllerPasswordText),
            ),
          ],
        ),
      ),
    );
  }
}
