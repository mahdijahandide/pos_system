import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/services/model/customer_address_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';

import '../../views/dialogs/loading_dialogs.dart';
import '../remotes/remote_status_handler.dart';
import 'auth_controller.dart';

class AddressController extends GetxController {
  RxBool focusTitle = false.obs;
  RxBool focusBlock = false.obs;
  RxBool focusStreet = false.obs;
  RxBool focusAvenue = false.obs;
  RxBool focusHouseApartment = false.obs;
  RxBool focusFloor = false.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController avenueController = TextEditingController();
  TextEditingController houseApartmanController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  Future<void> getCustomerAddressRequest({required String customerId}) async {
    var url = getCustomerAddress(customerId);
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}'
      },
    );
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());
      Get.find<CustomerController>()
          .customerList
          .where((element) => element.id.toString() == customerId)
          .first
          .hasAddress
          .value = true;

      jsonObject['data'].forEach((element) {
        Get.find<CustomerController>()
            .customerList
            .where((element) => element.id.toString() == customerId)
            .first
            .addressList
            .value
            .add(CustomerAddressModel(data: element));
        print(Get.find<CustomerController>()
            .customerList
            .where((element) => element.id.toString() == customerId)
            .first
            .name);
        update();
      });

      update();
      Get.find<CustomerController>().update();
    } else {
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  Future<void> addAddressRequest({required String customerId}) async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = createNewAddress(customerId);
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{
          'title': titleController.text,
          'country': Get.find<CartController>().selectedNewCountryId,
          'state': Get.find<CartController>().selectedNewProvinceId,
          'area': Get.find<CartController>().selectedNewAreaId,
          'block': blockController.text,
          'street': streetController.text,
          'avenue': avenueController.text,
          'house': houseApartmanController.text,
          'floor': floorController.text
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());
      Get.back();

      titleController.text = '';
      blockController.text = '';
      streetController.text = '';
      avenueController.text = '';
      houseApartmanController.text = '';
      floorController.text = '';

      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  Future<void> deleteCustomerAddressRequest(
      {required String customerId, required String addressId}) async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = deleteCustomerAddress(customerId, addressId);
    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}'
      },
    );
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);

      var currentCustomer = Get.find<CustomerController>()
          .customerList
          .where((element) => element.id.toString() == customerId)
          .first;

      int currentAddressIndex = currentCustomer.addressList.value
          .indexWhere((element) => element.id.toString() == addressId);

      currentCustomer.addressList.value.removeAt(currentAddressIndex);
      currentCustomer.addressList.refresh();
      update();
      Get.find<CustomerController>().update();
      Get.back();
    } else {
      // RemoteStatusHandler().errorHandler(
      //     code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }
}
