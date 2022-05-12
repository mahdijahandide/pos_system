import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';

import '../../../components/buttons/custom_text_button.dart';
import '../../../components/textfields/textfield.dart';
import '../../../components/texts/customText.dart';



class AddCustomerModal{

  Widget createModal(){
    return Container(
        color: Colors.white,
        //padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          Container(
            color: Colors.grey.withOpacity(0.5),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                CustomText().createText(title: 'Add Customer',size: 18,fontWeight: FontWeight.bold),
                InkWell(onTap: (){
                  Get.back();
                },child:const Icon(Icons.close,color: Colors.red,size: 23,)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                CustomTextField()
                    .createTextField(hint: 'Name', height: 50,controller: Get.find<CustomerController>().addCustomerNameController),
                const SizedBox(
                  height: 8.0,
                ),
                CustomTextField()
                    .createTextField(hint: 'Mobile', height: 50,controller: Get.find<CustomerController>().addCustomerNumberController),
                const SizedBox(
                  height: 8.0,
                ),
                CustomTextField()
                    .createTextField(hint: 'Email', height: 50,controller: Get.find<CustomerController>().addCustomerEmailController),
                const Expanded(child: SizedBox()),
                SizedBox(
                    width: 150,
                    height: 60,
                    child: CustomTextButton().createTextButton(
                      onPress: (){
                        if(Get.find<CustomerController>().addCustomerNameController.text.isNotEmpty&&Get.find<CustomerController>().addCustomerNumberController.text.isNotEmpty){
                          Get.find<CustomerController>().addCustomerRequest();
                        }else{
                          Snack().createSnack(title: 'warning',msg: 'please fill the form',bgColor: Colors.deepOrange,icon: Icons.warning);
                        }
                      },
                        elevation: 6,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        buttonText: 'Add',
                        buttonColor: Colors.teal,
                        textColor: Colors.white))
              ],
            ),
          ),
        ],)

    );
  }

}