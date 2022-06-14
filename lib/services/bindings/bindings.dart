import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/controller/order_controller.dart';

import '../controller/cart_controller.dart';
import '../controller/cash_controller.dart';
import '../controller/category_controller.dart';
import '../controller/customer_controller.dart';
import '../controller/dashboard_controller.dart';
import '../controller/product_controller.dart';
import '../controller/shift_controller.dart';
import '../controller/user_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(OrderController());
    Get.put(ProductController());
    Get.put(DashboardController());
    Get.put(UserController());
    Get.put(CategoryController());
    Get.put(CartController());
    Get.put(CustomerController());
    Get.put(CashController());
    Get.lazyPut(() => ShiftController());
  }
}
