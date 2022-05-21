import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/user_controller.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class DesktopProfile extends StatelessWidget {
  const DesktopProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (UserController controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,backgroundColor: Colors.grey.withOpacity(0.5),
            title: CustomText().createText(
                title: 'profile'.tr, size: 18, fontWeight: FontWeight.bold),
            actions: [
              InkWell(
                onTap: (){
                  if(Get.find<UserController>().hasEdit.isFalse){
                    Get.find<UserController>().hasEdit.value=true;
                    Get.find<UserController>().nameController.text=Get.find<UserController>().name;
                    Get.find<UserController>().emailController.text=Get.find<UserController>().email;
                    Get.find<UserController>().mobileController.text=Get.find<UserController>().mobile;
                    Get.find<UserController>().update();
                  }else{
                    Get.find<UserController>().hasEdit.value=false;
                    Get.find<UserController>().updateProfile();
                    Get.find<UserController>().update();
                  }
                },
                child: Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 15),
                  child:Get.find<UserController>().hasEdit.isFalse ?const Icon(Icons.edit):const Icon(Icons.check),
                ),
              )
            ],
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical:20),
              width: Get.width/2,padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
              child: Wrap(
                children: [
                  Get.find<UserController>().hasEdit.isTrue?
                      CustomTextField().createTextField(hint: 'name', height: 50,controller: Get.find<UserController>().nameController):
                  CustomText().createSpaceKeyVal(
                      keyText: 'Name',
                      valText: Get.find<UserController>().name,
                      keyFontWeight: FontWeight.bold,
                      valFontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
                  const Divider(),
                  // CustomText().createSpaceKeyVal(
                  //     keyText: 'lastName'.tr,
                  //     valText: Get.find<UserController>().lastName,
                  //     keyFontWeight: FontWeight.bold,
                  //     valFontWeight: FontWeight.bold,
                  //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
                  // const Divider(),
                  Get.find<UserController>().hasEdit.isTrue?
                      CustomTextField().createTextField(hint: 'enter email', height: 50,controller: Get.find<UserController>().emailController):
                  CustomText().createSpaceKeyVal(
                      keyText: 'email'.tr,
                      valText: Get.find<UserController>().email,
                      keyFontWeight: FontWeight.bold,
                      valFontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
                  const Divider(),
                  Get.find<UserController>().hasEdit.isTrue?
                      CustomTextField().createTextField(hint: 'enter mobile', height: 50,controller: Get.find<UserController>().mobileController):
                  CustomText().createSpaceKeyVal(
                      keyText: 'Mobile',
                      valText: Get.find<UserController>().mobile,
                      keyFontWeight: FontWeight.bold,
                      valFontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
                  // const Divider(),
                  // CustomText().createSpaceKeyVal(
                  //     keyText: 'isActive'.tr,
                  //     valText: Get.find<UserController>().isActive=='1'?'Active':'Deactive',
                  //     valColor: Get.find<UserController>().isActive=='1'?Colors.green:Colors.red,
                  //     keyFontWeight: FontWeight.bold,
                  //     valFontWeight: FontWeight.bold,
                  //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
