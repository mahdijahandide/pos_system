import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/remotes/api_routes.dart';

import '../../views/dialogs/loading_dialogs.dart';
import '../remotes/remote_status_handler.dart';



class ShiftController extends GetxController{

  RxDouble existCash=0.0.obs;
  RxDouble shouldExistCash=0.0.obs;
  RxDouble startCash=0.0.obs;
  RxDouble sellCash=0.0.obs;
  RxDouble sellCard=0.0.obs;
  RxDouble totalSell=0.0.obs;
  RxDouble refundCash=0.0.obs;
  RxDouble refundCard=0.0.obs;
  RxDouble totalRefund=0.0.obs;
  RxDouble total=0.0.obs;

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
      existCash.value=double.parse(jsonObject['data']['existCash'].toString());
      shouldExistCash.value=double.parse(jsonObject['data']['shouldExistCash'].toString());
      startCash.value=double.parse(jsonObject['data']['startCash'].toString());
      sellCash.value=double.parse(jsonObject['data']['sellCash'].toString());
      sellCard.value=double.parse(jsonObject['data']['sellCard'].toString());
      totalSell.value=double.parse(jsonObject['data']['totalSell'].toString());
      refundCash.value=double.parse(jsonObject['data']['refundCash'].toString());
      refundCard.value=double.parse(jsonObject['data']['refundCard'].toString());
      totalRefund.value=double.parse(jsonObject['data']['totalRefund'].toString());
      total.value=double.parse(jsonObject['data']['total'].toString());
      showLoading.value=false;
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode);
    }
  }
}