import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class DashboardDrawer {
  Widget createDrawer() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText().createText(title: 'POS-Admin'),
               IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () { Get.back(); },)
            ],
          ),
          // ListTile(leading: const Icon(Icons.vpn_key_rounded),title: CustomText().createText(title: 'Management'),onTap: (){},),
          // const Divider(),
          ListTile(leading: const Icon(Icons.history),title: CustomText().createText(title: 'View Sales history'),onTap: (){
            Get.find<OrderController>().getOrders();
          },),
          ListTile(leading: const Icon(Icons.group),title: CustomText().createText(title: 'View Customers'),onTap: (){
            // Get.find<CustomerController>().getCustomers(hasOpenPage: true);
            if(Get.find<CustomerController>().customerList.isNotEmpty){
              Get.toNamed('/customers');
            }else{
              Get.find<CustomerController>().getCustomers(hasOpenPage: true);
            }
          },),
          ListTile(leading: const Icon(Icons.money),title: CustomText().createText(title: 'Cash In / Out'),onTap: (){
            Get.toNamed('/cashInOut');
          },),
          ListTile(leading: const Icon(Icons.run_circle_outlined),title: CustomText().createText(title: 'End Of Day'),onTap: (){
            Get.toNamed('/endOfDay');
          },),
          ListTile(leading: const Icon(Icons.workspaces_filled),title: CustomText().createText(title: 'View All Products'),onTap: (){
            Get.toNamed('/allProduct');
          },),
          const Divider(),
          ListTile(leading: const Icon(Icons.person),title: CustomText().createText(title: 'User Info'),onTap: (){
            Get.toNamed('/profile');},),
          ListTile(leading: const Icon(Icons.logout),title: CustomText().createText(title: 'Sign Out'),onTap: (){
            Get.find<AuthController>().logoutRequest();
          },),
          const Divider(),
          ListTile(leading: const Icon(Icons.feedback),title: CustomText().createText(title: 'Feedback'),onTap: (){},),
          const Expanded(child: SizedBox()),
          Center(child: CustomText().createText(title: '06-Jan-22'),),
          const Divider(),
          const SizedBox(height: 12.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
            const Icon(Icons.settings),
            IconButton(onPressed: () {
              //document.documentElement.requestFullscreen();
              Get.find<DashboardController>().fullScreen();

            }, icon: const Icon(Icons.fullscreen),),
            const Icon(Icons.logout),
          ],)

        ],
      ),
    );
  }

  Widget keyValText(
      {required title,
        required value,
        dynamic keyWeight,
        dynamic valWeight,
        dynamic keySize,
        dynamic valSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: FittedBox(
                child: CustomText().createText(
                    title: title,
                    size: keySize ?? 16,
                    fontWeight: keyWeight ?? FontWeight.normal))),
        const SizedBox(
          width: 12,
        ),
        Flexible(
            child: FittedBox(
                child: CustomText().createText(
                    title: value,
                    size: valSize ?? 16,
                    fontWeight: valWeight ?? FontWeight.normal))),
      ],
    );
  }
}
