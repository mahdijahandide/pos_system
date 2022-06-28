import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/category_controller.dart';
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/pages/largePages/dashboard/desktop_dashboard.dart';
import 'package:pos_system/views/pages/largePages/dashboard/mobile_dashboard.dart';
import 'package:pos_system/views/pages/largePages/dashboard/tablet_dashboard.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<ProductController>().hasProduct.isFalse) {
      Get.find<ProductController>().getAllProducts(keyword: '', catId: '');
      Get.find<CategoryController>().getAllCategory();
      Get.lazyPut(() => OrderController());
    }

    return GetBuilder<ProductController>(
      builder: (logic) {
        return ScreenTypeLayout(
          desktop: DesktopDashboard(),
          tablet: TabletDashboard(),
          mobile: MobileDashboard(),
          watch: Container(color: Colors.white),
        );
      },
    );
  }
}
