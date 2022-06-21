import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/shimmer/product_shimmer.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/dialogs/refund_factor_num_dialog.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_drawer.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_main.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/iconTextBox.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/sidebar.dart';
import 'package:vk/vk.dart';
import 'package:printing/printing.dart';
import 'package:xid/xid.dart';

class DesktopDashboard extends GetView<DashboardController> {
  DesktopDashboard({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller.barcodeReader.addListener(controller.listener);
    return Scaffold(
        key: scaffoldKey,
        endDrawer: Drawer(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              height: Get.height,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: DashboardDrawer().createDrawer()),
        ),
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetX(builder: (CartController controller) {
                  return Row(
                    children: [
                      IconTextBox().createIconTextBox(
                          height: 70.0,
                          icon: Icons.add,
                          title: 'new_sale'.tr,
                          onTap: () {
                            if (controller.isRefund.isFalse) {
                              Get.find<CartController>().newSale();
                              Get.find<ProductController>()
                                  .productList
                                  .value
                                  .clear();
                              Get.find<ProductController>().hasProduct.value =
                                  false;
                              Get.find<ProductController>()
                                  .getAllProducts(catId: '', keyword: '');
                            } else {
                              Snack().createSnack(
                                  title: 'Warning',
                                  msg:
                                      'Can Not Using This Option On Refund Mode',
                                  bgColor: Colors.yellow,
                                  msgColor: Colors.black,
                                  titleColor: Colors.black);
                            }
                          }),
                      const SizedBox(
                        width: 12,
                      ),
                      IconTextBox().createIconTextBox(
                          height: 70.0,
                          borderColor: controller.isRefund.isTrue
                              ? Colors.greenAccent
                              : Colors.grey.withOpacity(0.5),
                          icon: Icons.redo_sharp,
                          title: 'refund'.tr,
                          fontWeight: controller.isRefund.isTrue
                              ? FontWeight.w900
                              : FontWeight.bold,
                          borderWidth: controller.isRefund.isTrue ? 4 : 2,
                          textSize: controller.isRefund.isTrue ? 22 : 16,
                          onTap: () {
                            if (controller.isRefund.isTrue) {
                              controller.newSale();
                              controller.isRefund.value = false;
                              Get.find<ProductController>()
                                  .productList
                                  .value
                                  .clear();
                              Get.find<ProductController>()
                                  .getAllProducts(catId: '', keyword: '');

                              Get.find<OrderController>()
                                  .orderList
                                  .value
                                  .clear();
                              Get.find<OrderController>()
                                  .orderFilteredList
                                  .value
                                  .clear();
                              Get.find<OrderController>()
                                  .orderItemsList
                                  .clear();
                              Get.find<OrderController>().hasList.value = false;
                              controller.update();
                            } else {
                              RefundFactorNumDialog.showCustomDialog(
                                  title: 'Refund');
                            }
                          }),
                      const SizedBox(
                        width: 12,
                      ),
                      IconTextBox().createIconTextBox(
                          height: 70.0,
                          icon: Icons.print,
                          title: 'Print'.tr,
                          onTap: () async {
                            await Printing.layoutPdf(
                                onLayout: (_) => controller.generatePdf());
                          }),
                    ],
                  );
                }),
                InkWell(
                    onTap: () {
                      scaffoldKey.currentState!.openEndDrawer();
                      // Scaffold.of(context).openEndDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      size: 45.0,
                    ))
              ],
            ),
          ),
        ),
        body: Obx(
          () => ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: Get.height,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: DashboardSidebar().createSidebar())),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        flex: 8,
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: Get.height,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Get.find<ProductController>()
                                        .productList
                                        .value
                                        .isEmpty ||
                                    Get.find<ProductController>()
                                        .hasProduct
                                        .isFalse
                                ? ProductShimmer().createProductShimmer(
                                    gridCnt: 5, isLarge: true)
                                : DashboardMain()
                                    .createMain(gridCnt: 5, isLarge: true))),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => Get.find<DashboardController>().isShowKeyboard.isTrue
              ? Container(
                  color: const Color(0xffeeeeee),
                  child: VirtualKeyboard(
                      focusNode: FocusNode(),
                      textColor: Colors.black,
                      type: Get.find<DashboardController>().isNumericMode
                          ? VirtualKeyboardType.Numeric
                          : VirtualKeyboardType.Alphanumeric,
                      textController:
                          Get.find<DashboardController>().searchController),
                )
              : const SizedBox(),
        ));
  }
}
