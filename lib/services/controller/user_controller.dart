import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';

import '../remotes/remote_status_handler.dart';

class UserController extends GetxController {

  String name = '';
  String lastName = '';
  String email = '';
  String mobile = '';
  String isActive = '';

  RxBool hasEdit=false.obs;

  TextEditingController nameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController mobileController= TextEditingController();


  Future<void> updateProfile() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = UPDATE_PROFILE;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
        'Authorization':'Bearer ${Get.find<AuthController>().token}'
      },
      body: jsonEncode(<String , String>{
        'name':nameController.text.toString(),
        'mobile':mobileController.text.toString(),
        'email':emailController.text.toString()
      })
    );
    if (response.statusCode == 200) {
      Get.back();
      var jsonObject = convert.jsonDecode(response.body);
      name=nameController.text.toString();
      email=emailController.text.toString();
      mobile=mobileController.text.toString();
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode,error: convert.jsonDecode(response.body));
      print(response.statusCode);
      // Get.log(response.body);
    }
  }
}
