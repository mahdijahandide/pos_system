import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/remotes/api_routes.dart';

import '../../views/dialogs/loading_dialogs.dart';
import '../remotes/remote_status_handler.dart';



class ShiftController extends GetxController{

  TextEditingController valController = TextEditingController();
  Rx<TextEditingController>cashCount=Rx(TextEditingController());
  Rx<TextEditingController>cardCount=Rx(TextEditingController());

  RxDouble startCash=0.0.obs;
  RxDouble sellCash=0.0.obs;
  RxDouble sellCard=0.0.obs;
  RxDouble cashIn=0.0.obs;
  RxDouble totalSell=0.0.obs;
  RxDouble totalFunds=0.0.obs;
  RxDouble totalRefund=0.0.obs;
  RxDouble refundCash=0.0.obs;
  RxDouble refundCard=0.0.obs;
  RxDouble totalCashFunds=0.0.obs;

  RxBool selectStartShift=true.obs;
  RxBool showLoading=true.obs;

  @override
  void onInit(){
    super.onInit();
    shiftDetailsRequest();
  }

  Future<void> shiftDetailsRequest() async {
    var url = SHIFT_DETAILS;
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
        'Authorization':'Bearer ${Get.find<AuthController>().token}'
      },
    );
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      selectStartShift.value=false;
      startCash.value=double.parse(jsonObject['data']['startCash'].toString());
      sellCash.value=double.parse(jsonObject['data']['sellCash'].toString());
      sellCard.value=double.parse(jsonObject['data']['sellCard'].toString());
      cashIn.value=double.parse(jsonObject['data']['cashIn'].toString());
      totalSell.value=double.parse(jsonObject['data']['totalSell'].toString());
      totalFunds.value=double.parse(jsonObject['data']['totalFunds'].toString());
      totalRefund.value=double.parse(jsonObject['data']['totalRefund'].toString());
      refundCash.value=double.parse(jsonObject['data']['refundCash'].toString());
      refundCard.value=double.parse(jsonObject['data']['refundCard'].toString());
      totalCashFunds.value=double.parse(jsonObject['data']['totalCashFunds'].toString());
      cashCount.value.text='0';
      cardCount.value.text='0';
      showLoading.value=false;
    } else if(response.statusCode==400) {
      showLoading.value=false;
      selectStartShift.value=true;
    }else{
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode,error: convert.jsonDecode(response.body));
    }
  }

  Future<void> startCashRequest({required starterValue}) async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = SHIFT_START;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
        'Authorization':'Bearer ${Get.find<AuthController>().token}'
      },
      body: jsonEncode(<String , String>{
        'startCash':'$starterValue'
      })
    );
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.back();
      shiftDetailsRequest();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode,error: convert.jsonDecode(response.body));
    }
  }

  Future<void> endCashRequest() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = SHIFT_END;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
        'Authorization':'Bearer ${Get.find<AuthController>().token}'
      },
      body: jsonEncode(<String,String>{
        'countCash':cashCount.value.text.toString(),
        'countCard':cardCount.value.text.toString(),
      })
    );
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      selectStartShift.value=true;
      Get.back();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode,error: convert.jsonDecode(response.body));
    }
  }
}