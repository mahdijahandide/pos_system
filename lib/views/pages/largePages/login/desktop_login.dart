import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/remotes/local_storage.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';
// import 'package:vk/vk.dart';

class DesktopLogin extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    controller.passFocus.value = false;
    controller.userFocus.value = true;
    return Scaffold(
      body: Obx(() {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              LocalStorageHelper.getValue('logo').toString() == 'null'
                  ? Column(
                      children: [
                        SizedBox(
                          width: Get.width < 1010.0 ? 75.0 : 200.0,
                          height: Get.height < 1010.0 ? 75.0 : 150.0,
                        ),
                        const CircularProgressIndicator(),
                        SizedBox(
                          width: Get.width < 1010.0 ? 75.0 : 200.0,
                          height: Get.height < 1010.0 ? 75.0 : 150.0,
                        ),
                      ],
                    )
                  : Image(
                      image: NetworkImage(
                        controller.posLogo.value,
                      ),
                      fit: BoxFit.contain,
                      width: Get.width < 1010.0 ? 150.0 : 400.0,
                      height: Get.height < 1010.0 ? 150.0 : 400.0,
                    ),
              CustomText().createText(
                  title: controller.systemName.value == 'null'
                      ? ''
                      : controller.systemName.value,
                  fontWeight: FontWeight.bold,
                  size: 24),
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
                      node: controller.userFocusNode,
                      hasSuffixIcon: false,
                      hasPrefixIcon: true,
                      onTap: () {
                        controller.userFocusNode.requestFocus();
                        controller.passFocus.value = false;
                        controller.userFocus.value = true;
                        controller.update();
                      },
                      prefixIcon: Icons.person)),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 600,
                child: CustomTextField().createTextField(
                    hint: '',
                    height: 45.0,
                    onTap: () {
                      controller.passFocusNode.requestFocus();
                      controller.userFocus.value = false;
                      controller.passFocus.value = true;
                      controller.update();
                    },
                    onSubmitted: (_) async {
                      controller.loginRequest();
                    },
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
              // CustomText().createText(
              //     title: 'forgot_password'.tr,
              //     fontWeight: FontWeight.normal,
              //     size: 16,
              //     color: Colors.blue),
              const Expanded(child: SizedBox()),

              createUserKeyboard(),
              createPassKeyboard(),
            ],
          ),
        );
      }),
    );
  }

  Widget createUserKeyboard() {
    if (controller.userFocus.isTrue) {
      return Container(
        color: Colors.grey.withOpacity(0.5),
        child: VirtualKeyboard(
          focusNode: FocusNode(),
          height: 350,
          textColor: Colors.black,
          fontSize: 40,
          type: VirtualKeyboardType.Alphanumeric,
          textController: controller.loginControllerUserText,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createPassKeyboard() {
    if (controller.passFocus.isTrue) {
      return Container(
        color: Colors.grey.withOpacity(0.5),
        child: VirtualKeyboard(
          focusNode: FocusNode(),
          height: 350,
          textColor: Colors.black,
          fontSize: 40,
          type: VirtualKeyboardType.Alphanumeric,
          textController: controller.loginControllerPasswordText,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
