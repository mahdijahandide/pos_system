import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/services/controller/address_controller.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/model/customer_model.dart';
import 'package:pos_system/services/model/string_with_string.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/dialogs/customer_autocomplete_dialog.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../remotes/remote_status_handler.dart';

class CustomerController extends GetxController {
  List<CustomerModel> customerList = [];
  List<StringWithString> customerName = [];
  RxString selectedCustomerName = ''.obs;
  var selectedCustomer;
  RxBool hasCustomer = false.obs;

  RxBool focusName = false.obs;
  RxBool focusNumber = false.obs;
  RxBool focusEmail = false.obs;
  RxBool isShowKeyboard = false.obs;

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();

  TextEditingController addCustomerNameController = TextEditingController();
  TextEditingController addCustomerNumberController = TextEditingController();
  TextEditingController addCustomerEmailController = TextEditingController();

  TextEditingController searchController = TextEditingController();

  TextEditingController customerController = TextEditingController();

  Rx<List<CustomerModel>> foundPlayers = Rx<List<CustomerModel>>([]);

  @override
  void onInit() {
    super.onInit();
    foundPlayers.value = customerList;
  }

  @override
  void onClose() {}
  void filterPlayer(String playerName) {
    List<CustomerModel> results = [];
    if (playerName.isEmpty) {
      results = customerList;
    } else {
      results = customerList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(playerName.toLowerCase()))
          .toList();
      if (results.isEmpty) {
        results = customerList
            .where((element) => element.mobile
                .toString()
                .toLowerCase()
                .contains(playerName.toLowerCase()))
            .toList();
      }
    }
    foundPlayers.value = results;
  }

  Future<void> getCustomers(
      {dynamic hasOpenPage, dynamic doInBackground, dynamic hasLoading}) async {
    customerList.clear();
    if (hasLoading != false) {
      LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    }
    var url = GET_Customers;
    final http.Response response =
        await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthController>().token}'
    });
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      hasCustomer.value = true;
      Get.log(jsonObject.toString());
      jsonObject['data'].forEach((element) {
        customerList.add(CustomerModel(data: element));
      });

      for (int i = 0; i < customerList.length; i++) {
        customerName.add(StringWithString(
            mName: customerList[i].name.toString(),
            mNum: customerList[i].mobile.toString()));
      }
      if (hasLoading != false) {
        Get.back();
      }

      if (doInBackground != true) {
        if (hasOpenPage != null) {
          Get.toNamed('/customers');
        } else {
          CustomerAutoCompleteDialog.showCustomDialog(
              title: 'Customer', list: customerName);
        }
      }
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  Future<void> addCustomerRequest(
      {dynamic shouldSelect, dynamic createCustomerAddress}) async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = ADD_NEW_CUSTOMER;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}'
      },
      body: jsonEncode(<String, String>{
        'name': addCustomerNameController.text,
        'email': addCustomerEmailController.text,
        'mobile': addCustomerNumberController.text,
      }),
    );
    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());

      customerList.add(CustomerModel(data: jsonObject['data']));
      customerName.add(StringWithString(
          mName: jsonObject['data']['name'],
          mNum: jsonObject['data']['mobile']));

      if (shouldSelect == true) {
        selectedCustomer = customerList
            .where(
                (element) => element.mobile == addCustomerNumberController.text)
            .first;
        if (selectedCustomer != null) {
          customerNameController.text = selectedCustomer.name ?? '';
          customerEmailController.text = selectedCustomer.email ?? '';
          customerNumberController.text = selectedCustomer.mobile ?? '';
          searchController.text = selectedCustomer.mobile ?? '';
        } else {
          Get.find<CustomerController>().customerNameController.text = '';
          Get.find<CustomerController>().customerEmailController.text = '';
          Get.find<CustomerController>().customerNumberController.text = '';
        }
      }

      addCustomerNameController.text = '';
      addCustomerEmailController.text = '';
      addCustomerNumberController.text = '';

      if (createCustomerAddress == true) {
        Get.find<AddressController>().addAddressRequest(
            customerId: jsonObject['data']['id'].toString(),
            shouldSelectAddress: shouldSelect);
      }

      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }
}
