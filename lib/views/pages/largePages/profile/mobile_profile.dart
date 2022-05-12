import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/user_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class MobileProfile extends StatelessWidget {
  const MobileProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: 'profile'.tr, size: 18, fontWeight: FontWeight.bold),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          CustomText().createSpaceKeyVal(
              keyText: 'Name',
              valText: Get.find<UserController>().name,
              keyFontWeight: FontWeight.bold,
              valFontWeight: FontWeight.bold,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
          // const Divider(),
          // CustomText().createSpaceKeyVal(
          //     keyText: 'lastName'.tr,
          //     valText: Get.find<UserController>().lastName,
          //     keyFontWeight: FontWeight.bold,
          //     valFontWeight: FontWeight.bold,
          //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
          const Divider(),
          CustomText().createSpaceKeyVal(
              keyText: 'email'.tr,
              valText: Get.find<UserController>().email,
              keyFontWeight: FontWeight.bold,
              valFontWeight: FontWeight.bold,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
          const Divider(),
          CustomText().createSpaceKeyVal(
              keyText: 'Mobile',
              valText: Get.find<UserController>().mobile,
              keyFontWeight: FontWeight.bold,
              valFontWeight: FontWeight.bold,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
          // const Divider(),
          // CustomText().createSpaceKeyVal(
          //     keyText: 'isActive'.tr,
          //     valText:  Get.find<UserController>().isActive=='1'?'Active':'Deactive',
          //     valColor: Get.find<UserController>().isActive=='1'?Colors.green:Colors.red,
          //     keyFontWeight: FontWeight.bold,
          //     valFontWeight: FontWeight.bold,
          //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
        ],
      ),
    );
  }
}
