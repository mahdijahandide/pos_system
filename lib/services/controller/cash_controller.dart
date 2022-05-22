import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/services/remotes/remote_status_handler.dart';

import '../../views/components/snackbar/snackbar.dart';
import '../../views/dialogs/loading_dialogs.dart';

class CashController extends GetxController{
  RxBool isAddCash=true.obs;
  TextEditingController amountTextController=TextEditingController();
  TextEditingController descriptionTextController=TextEditingController();

  Future<void> addOrRemoveCashRequest() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = CASH_IN_OUT;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type':'application/json',
      },
      body: jsonEncode(<String, String>{
        'type': isAddCash.isFalse?"out":"in",
        'amount': amountTextController.text,
        'description': descriptionTextController.text,
      }),
    );
    if (response.statusCode == 200) {
      Get.back();
      var jsonObject = convert.jsonDecode(response.body);
      amountTextController.clear();
      descriptionTextController.clear();
      Snack().createSnack(title: 'success',msg: 'request recorded successfully');
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode,error:convert.jsonDecode(response.body));
    }
  }
}