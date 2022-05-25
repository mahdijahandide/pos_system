import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/model/order_item_model.dart';
import 'package:pos_system/services/model/order_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/pages/largePages/saleHistory/order_items_modal.dart';

import '../../views/components/snackbar/snackbar.dart';
import '../../views/dialogs/loading_dialogs.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../remotes/remote_status_handler.dart';
import 'auth_controller.dart';


class OrderController  extends GetxController{

  Rx<List<OrderModel>>orderList=Rx<List<OrderModel>>([]);
  Rx<List<OrderModel>>orderFilteredList=Rx<List<OrderModel>>([]);
  List<OrderItemsModel>orderItemsList=[];

  late OrderModel selectedItem;

  RxBool hasList=false.obs;

  Future<void> getOrders({dynamic id,dynamic reqStatus}) async {
    orderList.value.clear();
    if(reqStatus=='refund'){
      LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    }
    var url = GET_ORDERS;
    final http.Response response =
    await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthController>().token}'
    },body: jsonEncode(<String,String>{
      if(reqStatus=='refund')
      'search_order_id':id.toString()
    }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);

      if(reqStatus=='refund'){
        if(jsonObject['data']['orders'][0]['order_status'].toString()=='completed'){
          Get.find<CartController>().refundCartTotalPrice=jsonObject['data']['orders'][0]['total_amount'].toString();
          Get.find<CartController>().isRefund.value=!Get.find<CartController>().isRefund.value;
        }else{
          Get.back();
          Snack().createSnack(title: 'warning',msg: 'cant refund this factor');
        }
      }else{
        jsonObject['data']['orders'].forEach((element) {
          orderList.value.add(OrderModel(data: element));
        });
        orderFilteredList.value=orderList.value;
        hasList.value=true;
      }
      if(reqStatus=='refund'){
        Get.back();
      }
        //Get.toNamed('/saleHistory');
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode,error:convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  Future<void> getOrderProducts({required id,dynamic current}) async {
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
      RemoteStatusHandler().errorHandler(code: response.statusCode,error:convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

}