import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/model/cash_history_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/services/remotes/remote_status_handler.dart';

import '../../views/components/snackbar/snackbar.dart';
import '../../views/dialogs/loading_dialogs.dart';
import 'auth_controller.dart';

class CashController extends GetxController {
  RxBool isAddCash = true.obs;
  TextEditingController amountTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

  Rx<List<CashHistoryModel>> cashHistoryList = Rx<List<CashHistoryModel>>([]);
  RxBool hasHistoryList = false.obs;

  Future<void> addOrRemoveCashRequest() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = CASH_IN_OUT;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}'
      },
      body: jsonEncode(<String, String>{
        'type': isAddCash.isFalse ? "out" : "in",
        'amount': amountTextController.text,
        'description': descriptionTextController.text,
      }),
    );
    if (response.statusCode == 200) {
      Get.back();
      var jsonObject = convert.jsonDecode(response.body);
      amountTextController.clear();
      descriptionTextController.clear();
      Snack().createSnack(
          title: 'Success',
          msg: 'Request Recorded Successfully',
          bgColor: Colors.green,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ));
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> getCashHistory() async {
    var url = CASH_HISTORY;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}'
      },
    );
    if (response.statusCode == 200) {
      cashHistoryList.value.clear();
      var jsonObject = convert.jsonDecode(response.body);
      jsonObject['data'].forEach((element) {
        cashHistoryList.value.add(CashHistoryModel(data: element));
      });
      hasHistoryList.value = true;
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }
}
