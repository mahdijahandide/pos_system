import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';


class MobileLogin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(image: AssetImage('assets/images/png/logo.png',),width: 200,height: 200,),
            CustomText().createText(title: 'aronium'.tr,fontWeight: FontWeight.bold,size: 22),
            const SizedBox(height: 30,),
            CustomText().createText(title: 'login'.tr,fontWeight: FontWeight.normal,size: 16),
            const SizedBox(height: 15,),
            SizedBox(
                width: 300,
                child: CustomTextField().createTextField(
                    hint: '',
                    height: 45.0,
                    controller: Get.find<AuthController>().loginControllerUserText,
                    borderColor: Colors.blue,
                    align: TextAlign.start,
                    hasSuffixIcon: false,
                    hasPrefixIcon: true,
                    prefixIcon: Icons.person
                )
            ),
            const SizedBox(height: 8,),
            SizedBox(
              width: 300,
              child: CustomTextField().createTextField(
                  hint: '',
                  height: 45.0,
                  controller: Get.find<AuthController>().loginControllerPasswordText,
                  borderColor: Colors.blue,
                  obscure: true,
                  align: TextAlign.start,
                  hasSuffixIcon: true,
                  hasPrefixIcon: true,
                  prefixIcon: Icons.lock,
                  suffixIcon: Icons.arrow_forward,
                  suffixPress: (){Get.find<AuthController>().loginRequest();}
              ),
            ),
            const SizedBox(height: 15,),
            CustomText().createText(title: 'forgot_password'.tr,fontWeight: FontWeight.normal,size: 16,color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
