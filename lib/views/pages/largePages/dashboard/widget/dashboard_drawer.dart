import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:universal_html/html.dart' as html;

import '../../../../../services/remotes/api_routes.dart';
import '../../../../components/snackbar/snackbar.dart';

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
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          // ListTile(leading: const Icon(Icons.vpn_key_rounded),title: CustomText().createText(title: 'Management'),onTap: (){},),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: CustomText().createText(title: 'View Sales History'),
            onTap: () {
              Get.close(1);
              if (Get.find<CartController>().isRefund.isFalse) {
                Get.toNamed('/saleHistory');
              } else {
                Snack().createSnack(
                    title: 'Warning',
                    msg: 'Can Not Using This Option On Refund Mode',
                    bgColor: Colors.yellow,
                    msgColor: Colors.black,
                    titleColor: Colors.black);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: CustomText().createText(title: 'View Customers'),
            onTap: () {
              Get.close(1);
              if (Get.find<CustomerController>().customerList.isNotEmpty) {
                Get.toNamed('/customers');
              } else {
                Get.find<CustomerController>().getCustomers(hasOpenPage: true);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: CustomText().createText(title: 'Cash In / Out'),
            onTap: () {
              Get.close(1);
              Get.toNamed('/cashInOut');
            },
          ),
          ListTile(
            leading: const Icon(Icons.run_circle_outlined),
            title: CustomText().createText(title: 'Start/End Shift'),
            onTap: () {
              Get.close(1);
              Get.toNamed('/endOfDay');
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspaces_filled),
            title: CustomText().createText(title: 'View All Products'),
            onTap: () {
              Get.close(1);
              if (Get.find<CartController>().isRefund.isFalse) {
                Get.find<DashboardController>().showProductDetails.value =
                    false;
                Get.find<DashboardController>().allProductViewDetails.value =
                    true;
                Get.toNamed('/allProduct');
              } else {
                Snack().createSnack(
                    title: 'Warning',
                    msg: 'Can Not Using This Option On Refund Mode',
                    bgColor: Colors.yellow,
                    msgColor: Colors.black,
                    titleColor: Colors.black);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: CustomText().createText(title: 'User Info'),
            onTap: () {
              Get.close(1);
              Get.toNamed('/profile');
            },
          ),
          // ListTile(leading: const Icon(Icons.logout),title: CustomText().createText(title: 'Sign Out'),onTap: (){
          //   Get.find<AuthController>().logoutRequest();
          // },),
          // const Divider(),
          // ListTile(leading: const Icon(Icons.feedback),title: CustomText().createText(title: 'Feedback'),onTap: (){},),
          const Expanded(child: SizedBox()),
          Center(
            child: CustomText().createText(
                title: DateTime.now().year.toString() +
                    '-' +
                    DateTime.now().month.toString() +
                    '-' +
                    DateTime.now().day.toString()),
          ),
          const Divider(),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.monitor),
                onPressed: () {
                  Get.close(1);
                  html.WindowBase _popup = html.window.open(
                      '$DOMAIN/#/showFactor',
                      'Pos system',
                      'left=100,top=100,width=800,height=600');
                  if (_popup.closed!) {
                    throw ("Popups blocked");
                  }
                },
              ),
              IconButton(
                onPressed: () {
                  Get.find<ProductController>().hasProduct.value = false;
                  Get.find<DashboardController>().fullScreen();
                  Get.back(closeOverlays: true, canPop: true);
                },
                icon: const Icon(Icons.fullscreen),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Get.find<AuthController>().logoutRequest();
                },
              ),
            ],
          )
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
