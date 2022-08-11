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

  RxString selectedCustomerAddressTitle = ''.obs;
  String selectedCustomerAddressId = '';

  CustomerAddressModel? selectedAddress;

  RxList<CustomerAddressModel> addresses = RxList([]);

  Future<void> getCustomerAddressRequest(
      {required String customerId, dynamic hasLoading,dynamic closeOverLays}) async {
    if (hasLoading == true) {
      LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    }
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
      if (jsonObject['data'] == null) {
        selectedCustomerAddressTitle.value = '';
        selectedCustomerAddressId = '';
        selectedAddress = null;
        if (hasLoading == true) {
          closeOverLays==false?Get.back():
          Get.back(closeOverlays: true,);
        }
      }
      Get.log(jsonObject.toString());
      Get.find<CustomerController>()
          .customerList
          .where((element) => element.id.toString() == customerId)
          .first
          .hasAddress
          .value = true;

      Get.find<CustomerController>()
          .customerList
          .where((element) => element.id.toString() == customerId)
          .first
          .addressList.value
          .clear();


      jsonObject['data'].forEach((element) {
        Get.find<CustomerController>()
            .customerList
            .where((element) => element.id.toString() == customerId)
            .first
            .addressList
            .value
            .add(CustomerAddressModel(data: element));

        Get
            .find<AddressController>()
            .addresses
            .value = Get
            .find<CustomerController>()
            .selectedCustomer
            .addressList;

        update();
        Get.find<CartController>().update();

      });

      update();
      Get.find<CustomerController>().update();
      Get.find<CartController>().update();
      if (hasLoading == true) {
        selectedCustomerAddressTitle.value = '';
        selectedCustomerAddressId = '';
        selectedAddress = null;
        closeOverLays==false?Get.back():
        Get.back(closeOverlays: true,);
      }
      Get.find<CartController>().update();
      Get.find<AddressController>().update();
      update();
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

  Future<void> updateCustomerAddressRequest({
    required String customerId,
    required String addressId,
    required String countryName,
    required String stateName,
    required String areaName,
  }) async {
    Get.back();
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = updateCustomerAddress(customerId, addressId);
    final http.Response response = await http.put(Uri.parse(url),
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

      var currentCustomer = Get.find<CustomerController>()
          .customerList
          .where((element) => element.id.toString() == customerId)
          .first;

      int currentAddressIndex = currentCustomer.addressList.value
          .indexWhere((element) => element.id.toString() == addressId);

      currentCustomer.addressList[currentAddressIndex].title =
          titleController.text;
      currentCustomer.addressList[currentAddressIndex].countryId =
          int.parse(Get.find<CartController>().selectedNewCountryId);
      currentCustomer.addressList[currentAddressIndex].stateId =
          int.parse(Get.find<CartController>().selectedNewProvinceId);
      currentCustomer.addressList[currentAddressIndex].areaId =
          int.parse(Get.find<CartController>().selectedNewAreaId);
      currentCustomer.addressList[currentAddressIndex].countryName =
          countryName;
      currentCustomer.addressList[currentAddressIndex].stateName = stateName;
      currentCustomer.addressList[currentAddressIndex].areaName = areaName;
      currentCustomer.addressList[currentAddressIndex].block =
          blockController.text;
      currentCustomer.addressList[currentAddressIndex].avenue =
          avenueController.text;
      currentCustomer.addressList[currentAddressIndex].street =
          streetController.text;
      currentCustomer.addressList[currentAddressIndex].house =
          houseApartmanController.text;
      currentCustomer.addressList[currentAddressIndex].floor =
          floorController.text;

      titleController.text = '';
      blockController.text = '';
      streetController.text = '';
      avenueController.text = '';
      houseApartmanController.text = '';
      floorController.text = '';
      currentCustomer.addressList.refresh();
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
