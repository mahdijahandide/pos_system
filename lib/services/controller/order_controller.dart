import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/address_controller.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/model/cart_product_model.dart';
import 'package:pos_system/services/model/order_item_model.dart';
import 'package:pos_system/services/model/order_model.dart';
import 'package:pos_system/services/model/product_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/pages/largePages/saleHistory/order_items_modal.dart';

import '../../views/components/snackbar/snackbar.dart';
import '../../views/dialogs/loading_dialogs.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../remotes/remote_status_handler.dart';
import 'auth_controller.dart';

class OrderController extends GetxController {
  Rx<List<OrderModel>> orderList = Rx<List<OrderModel>>([]);
  Rx<List<OrderModel>> orderFilteredList = Rx<List<OrderModel>>([]);
  List<OrderItemsModel> orderItemsList = [];

  RxString selectedFilteredDate = ''.obs;

  late OrderModel selectedItem;

  double orderRefundSellerDiscount = 0.0;
  double orderRefundTotalAmount = 0.0;
  double orderRefundDeliveryAmount = 0.0;

  RxBool hasList = false.obs;

  var discountNesbat;

  Future<void> getOrders(
      {dynamic id, dynamic reqStatus, dynamic isRefund}) async {
    print(jsonEncode(<String, dynamic>{
      if (reqStatus == 'refund') 'search_order_id': id.toString(),
      if (isRefund != null) 'checkUser': '0'
    }));
    orderList.value.clear();
    if (reqStatus == 'refund') {
      LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    }
    var url = GET_ORDERS;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{
          if (reqStatus == 'refund') 'search_order_id': id.toString(),
          if (isRefund == false) 'checkUser': '0'
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      hasList.value = true;
      if (reqStatus == 'refund') {
        if (jsonObject['data'].toString() != '[]' &&
            jsonObject['data']['orders'][0]['order_status'].toString() ==
                'completed') {
          double delivery =
              jsonObject['data']['orders'][0]['delivery_charges'] ?? 0.0;
          Get.find<CartController>().refundCartTotalPrice = (double.parse(
                      jsonObject['data']['orders'][0]['total_amount']
                          .toString()) -
                  delivery)
              .toString();
          // Get.find<CartController>().discountAmount=jsonObject
          Get.find<CartController>().isRefund.value =
              !Get.find<CartController>().isRefund.value;
          Get.find<CartController>().saveCartForSecondMonitor();
          Get.find<CartController>().refundFactorItemList.value.clear();
          Get.find<ProductController>().productList.value.clear();
          Get.find<ProductController>().update();
          getOrderProducts(id: jsonObject['data']['orders'][0]['id']);

          Get.find<CartController>().newSale(canTemp: true);
          Get.find<CartController>().update();
        } else {
          Get.back();
          Snack().createSnack(
              title: 'Warning',
              msg: 'Can Not Refund This Invoice',
              bgColor: Colors.red);
        }
        Snack().createSnack(
            title: 'Warning',
            msg: 'Can Not Refund This Invoice',
            bgColor: Colors.red);
        Get.back();
      }
      if (jsonObject['data'].toString() != '[]') {
        jsonObject['data']['orders'].forEach((element) {
          orderList.value.add(OrderModel(data: element));
        });
        orderFilteredList.value = orderList.value;
      }
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  Future<void> getOrderProducts(
      {required id, dynamic current, dynamic showModal}) async {
    orderItemsList.clear();
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = GET_ORDER_ITEMS;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{
          'order_id': id.toString(),
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);

      if (Get.find<CartController>().isRefund.isFalse) {
        jsonObject['data']['orderItems'].forEach((element) {
          orderItemsList.add(OrderItemsModel(data: element));
        });
        var discount = jsonObject['data']['details']['seller_discount'];
        var delivery = jsonObject['data']['details']['delivery_charges'];
        var subtotal = jsonObject['data']['subTotal'];
        var totalPaid = jsonObject['data']['pay'];
        var totalAmount = jsonObject['data']['total'];
        var details = jsonObject['data']['details'];
        Get.find<CartController>().totalAmountForPrint = totalAmount ?? 0.0;
        Get.find<CartController>().totalPaidForPrint = totalPaid ?? 0.0;
        Get.find<CartController>().subTotalAmountForPrint = subtotal ?? 0.0;
        Get.find<CartController>().discountAmountForPrint = discount ?? 0.0;
        Get.find<CartController>().deliveryAmountForPrint = delivery ?? 0.0;

        String country = details['countryName']['en'].toString() != ''
            ? details['countryName']['en'].toString()
            : '';

        String province = details['stateName']['en'].toString() != ''
            ? details['stateName']['en'].toString()
            : '';
        String area = details['areaName']['en'].toString() != ''
            ? details['areaName']['en'].toString()
            : '';

        String ave = details['avenue'].toString() != ''
            ? 'ave:${details['avenue'].toString()}'
            : '';

        String st = details['street'].toString() != ''
            ? 'st:${details['street'].toString()}'
            : '';

        String house = details['house'].toString() != ''
            ? 'house:${details['house'].toString()}'
            : '';
        String floor = details['floor'].toString() != ''
            ? 'floor:${details['floor'].toString()}'
            : '';
        String block = details['block'].toString() != ''
            ? 'block:${details['block'].toString()}'
            : '';

        String address = '';
        if (country != '' ||
            province != '' ||
            area != '' ||
            ave != '' ||
            st != '' ||
            house != '' ||
            floor != '' ||
            block != '') {
          address = 'Customer Address: ';
        }

        Get.find<CartController>().customerAddressForPrint =
            '$address $country $province $area $ave $st $house $floor $block';
        Get.back();
        selectedItem = current;
        Get.bottomSheet(
          OrderItemsModal().orderItems(),
          isScrollControlled: true,
          enableDrag: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        );
      } else {
        Get.find<CartController>().refundFactorItemList.value.clear();
        Get.find<ProductController>().productList.value.clear();
        orderRefundTotalAmount = double.parse(
            jsonObject['data']['details']['total_amount'].toString());

        if (jsonObject['data']['details']['delivery_charges'].toString() !=
            'null') {
          orderRefundDeliveryAmount = double.parse(
              jsonObject['data']['details']['delivery_charges'].toString());
        } else {
          orderRefundDeliveryAmount = 0.0;
        }

        if (jsonObject['data']['details']['seller_discount'].toString() !=
            'null') {
          orderRefundSellerDiscount = double.parse(
              jsonObject['data']['details']['seller_discount'].toString());

          Get.find<CartController>().discountAmount = orderRefundSellerDiscount;
        } else {
          orderRefundSellerDiscount = 0.0;
          Get.find<CartController>().discountAmount = orderRefundSellerDiscount;
        }
        discountNesbat = orderRefundSellerDiscount /
            (orderRefundTotalAmount -
                orderRefundDeliveryAmount +
                orderRefundSellerDiscount);

        jsonObject['data']['orderItems'].forEach((element) {
          Get.find<CartController>().refundFactorItemList.value.add(
              CartProductModel(
                  mId: int.parse(element['id'].toString()),
                  iCode: element['item_code'].toString(),
                  pId: element['product_id'].toString(),
                  mPrice: element['unitprice'].toString(),
                  mQuantity: element['quantity'].toString(),
                  mTitle: element['translate']['en'].toString(),
                  mTitleAr: element['translate']['ar'].toString(),
                  mTempUniqueId: ''));

          Get.find<ProductController>()
              .productList
              .value
              .add(ProductModel(data: element));
          Get.find<ProductController>().update();

          Get.back(closeOverlays: true);
          if (showModal == true) {
            orderItemsList.clear();
            selectedItem = current;
            jsonObject['data']['orderItems'].forEach((element) {
              orderItemsList.add(OrderItemsModel(data: element));
            });

            var discount = jsonObject['data']['details']['seller_discount'];
            var delivery = jsonObject['data']['details']['delivery_charges'];
            var subtotal = jsonObject['data']['subTotal'];
            var totalPaid = jsonObject['data']['pay'];
            var totalAmount = jsonObject['data']['total'];

            Get.find<CartController>().totalAmountForPrint = totalAmount ?? 0.0;
            Get.find<CartController>().totalPaidForPrint = totalPaid ?? 0.0;
            Get.find<CartController>().subTotalAmountForPrint = subtotal ?? 0.0;
            Get.find<CartController>().discountAmountForPrint = discount ?? 0.0;
            Get.find<CartController>().deliveryAmountForPrint = delivery ?? 0.0;
            Get.bottomSheet(
              OrderItemsModal().orderItems(),
              isScrollControlled: true,
              enableDrag: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            );
          }
        });
        Get.find<CartController>().deliveryAmount = orderRefundDeliveryAmount;
        Get.find<CartController>().totalAmount = orderRefundTotalAmount +
            orderRefundSellerDiscount -
            orderRefundDeliveryAmount;
        Get.find<CartController>().saveCartForSecondMonitor();
      }
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }
}
