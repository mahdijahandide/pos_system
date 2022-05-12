import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';

class TempOrderModel {
  String? tempId;
  String?tempTime;
  double?delivery;
  double?discount;
  final DateTime _now = DateTime.now();

  TempOrderModel({required mId,}) {
    tempId=mId;
    tempTime='Time: ${_now.hour}:${_now.minute}:${_now.second}';
    delivery=Get.find<CartController>().deliveryAmount;
    discount=Get.find<CartController>().discountAmount;
  }
}
