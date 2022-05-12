import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/controller/user_controller.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xid/xid.dart';

import 'category_controller.dart';
import 'dashboard_controller.dart';
import 'dart:js' as js;
import 'dart:html' as html;

class AuthController extends GetxController {
  // Holds the text that user typed.
  String text = '';
  String token = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  final TextEditingController loginControllerUserText = TextEditingController(text: 'admin');
  final TextEditingController loginControllerPasswordText = TextEditingController(text: 'kash5admin');
  FocusNode userFocus=FocusNode();
  FocusNode passwordFocus=FocusNode();

  Future<void> loginRequest() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = LOGIN_ROUTE;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': loginControllerUserText.text,
        'password': loginControllerPasswordText.text,
      }),
    );
    if (response.statusCode == 200) {
      Get.back();
      var jsonObject = convert.jsonDecode(response.body);
      token=jsonObject['token'];
      Get.find<UserController>().name=jsonObject['user']['name'];
      Get.find<UserController>().email=jsonObject['user']['email'];
      Get.find<UserController>().mobile=jsonObject['user']['mobile'];
      Get.toNamed('/dashboard');
      Get.find<CartController>().uniqueId='pos${Xid()}';

      Get.find<CustomerController>().getCustomers(doInBackground: true,hasLoading: false);
      Get.find<CartController>().getAreas(doInBackground: true,hasLoading: false);

      // html.WindowBase _popup = html.window
      //     .open('https://possystem.gulfweb.ir/#/showFactor/?params=${Get.find<CartController>().uniqueId}', 'Pos system', 'left=100,top=100,width=800,height=600');
      // if (_popup.closed!) {
      //   throw("Popups blocked");
      // }

    } else {
      Get.back();
      print(response.statusCode);
    }
  }

  Future<void> logoutRequest() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = LOGOUT_ROUTE;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
        'Authorization':'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      Get.back();
      var jsonObject = convert.jsonDecode(response.body);
      Get.offAndToNamed('/login');
    } else {
      Get.back();
      print(response.statusCode);
    }
  }

  void clearProject(){
    //auth controller
    text = '';
    token = '';
    shiftEnabled = false;
    isNumericMode = false;
    loginControllerUserText.text='';
    loginControllerPasswordText .text='';
    //cart controller
    Get.find<CartController>().uniqueId='';
    Get.find<CartController>(). cartPrice.value='';
    Get.find<CartController>().addToCartList = [];
    //category controller
    Get.find<CategoryController>().categoryList = [];
    Get.find<CategoryController>().categoryProductList = [];
    Get.find<CategoryController>().hasCategory.value = false;
    //dashboard controller
    Get.find<DashboardController>().isShowKeyboard=false.obs;
    Get.find<DashboardController>().text = '';
    Get.find<DashboardController>().shiftEnabled = false;
    Get.find<DashboardController>().isNumericMode = false;
    Get.find<DashboardController>().searchController.text ='' ;
    Get.find<DashboardController>().searchId=1.obs;
    //product controller
    Get.find<ProductController>(). productList = [];
    Get.find<ProductController>(). searchedProductList = [];
    Get.find<ProductController>(). productColorList = [];
    Get.find<ProductController>(). productSizeList = [];
    Get.find<ProductController>(). productSizeColorList = [];
    Get.find<ProductController>(). hasProduct = false.obs;
    Get.find<ProductController>(). selectedColorName = ''.obs;
    Get.find<ProductController>(). selectedSizeName = ''.obs;
    Get.find<ProductController>().  selectedColorId='';
    Get.find<ProductController>(). selectedSizeId='';
    //user controller
    Get.find<UserController>(). name = '';
    Get.find<UserController>(). lastName = '';
    Get.find<UserController>(). email = '';
    Get.find<UserController>(). mobile = '';
    Get.find<UserController>(). isActive = '';

    Get.find<UserController>(). hasEdit=false.obs;

    Get.find<UserController>(). nameController.text='';
    Get.find<UserController>(). emailController.text='';
    Get.find<UserController>(). mobileController.text='';
  }
}
