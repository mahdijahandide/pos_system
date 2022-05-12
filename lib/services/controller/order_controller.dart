import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/model/order_item_model.dart';
import 'package:pos_system/services/model/order_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/pages/largePages/saleHistory/order_items_modal.dart';

import '../../views/dialogs/loading_dialogs.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../../views/pages/largePages/modals/cash_modal.dart';
import '../remotes/remote_status_handler.dart';
import 'auth_controller.dart';


class OrderController  extends GetxController{

  List<OrderModel>orderList=[];
  Rx<List<OrderModel>>orderFilteredList=Rx<List<OrderModel>>([]);
  List<OrderItemsModel>orderItemsList=[];

  late OrderModel selectedItem;

  Future<void> getOrders() async {
    orderList.clear();
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = GET_ORDERS;
    final http.Response response =
    await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthController>().token}'
    });
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());
      jsonObject['data']['orders'].forEach((element) {
        orderList.add(OrderModel(data: element));
      });
      orderFilteredList.value=orderList;
      Get.back();
        Get.toNamed('/saleHistory');
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode);
      print(response.statusCode);
    }
  }

  Future<void> getOrderProducts({required id,required current}) async {
    orderItemsList.clear();
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = GET_ORDER_ITEMS;
    final http.Response response =
    await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthController>().token}'
    },
    body: jsonEncode(<String, String>{
      'order_id': id.toString(),
    }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());
      jsonObject['data']['orderItems'].forEach((element) {
        orderItemsList.add(OrderItemsModel(data: element));
      });
      Get.back();
      selectedItem=current;
      Get.bottomSheet(
        OrderItemsModal().orderItems(),
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      );

    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode);
      print(response.statusCode);
    }
  }

}