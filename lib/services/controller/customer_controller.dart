import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
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

  TextEditingController customerNameController=TextEditingController();
  TextEditingController customerEmailController=TextEditingController();
  TextEditingController customerNumberController=TextEditingController();

  TextEditingController addCustomerNameController=TextEditingController();
  TextEditingController addCustomerNumberController=TextEditingController();
  TextEditingController addCustomerEmailController=TextEditingController();

  TextEditingController customerController = TextEditingController();

  Rx<List<CustomerModel>> foundPlayers =
  Rx<List<CustomerModel>>([]);

  @override
  void onInit() {
    super.onInit();
    foundPlayers.value = customerList;
  }

  @override
  void onReady() {
    super.onReady();
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
      if(results.isEmpty){
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



  Future<void> getCustomers({dynamic hasOpenPage,dynamic doInBackground,dynamic hasLoading}) async {
    customerList.clear();
    if(hasLoading!=false){
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
      Get.log(jsonObject.toString());
      jsonObject['data'].forEach((element) {
        customerList.add(CustomerModel(data: element));
      });

      for(int i=0;i<customerList.length;i++){
        customerName.add(StringWithString(mName: customerList[i].name.toString(), mNum: customerList[i].mobile.toString()));
      }
      if(hasLoading!=false){
        Get.back();
      }

      if(doInBackground!=true){
        if(hasOpenPage!=null){
          Get.toNamed('/customers');
        }else{
          CustomerAutoCompleteDialog.showCustomDialog(title: 'Customer', list: customerName);
        }
      }

    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode);
      print(response.statusCode);
    }
  }

  Future<void> addCustomerRequest() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = ADD_NEW_CUSTOMER;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
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

      customerList.add(CustomerModel(data: jsonObject['data']));
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode);
      print(response.statusCode);
    }
  }
}
