import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_main.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:vk/vk.dart';
import '../../../components/texts/customText.dart';

class AllProduct extends StatelessWidget {
  int gridCtn;
  AllProduct({Key? key, required this.gridCtn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAndToNamed('/dashboard');
              Get.find<DashboardController>().showProductDetails.value = false;
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: 'All Products'.tr, size: 18, fontWeight: FontWeight.bold),
      ),
      body: WillPopScope(
        onWillPop: () => _willPopCallback(),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ScreenTypeLayout(
              desktop: DashboardMain()
                  .createMain(gridCnt: 5, noSideBar: true, ontap: true),
              tablet: DashboardMain()
                  .createMain(gridCnt: 3, noSideBar: true, ontap: true),
              mobile: DashboardMain().createMain(
                gridCnt: 2,
                noSideBar: true,
                ontap: true,
              ),
              watch: Container(color: Colors.white),
            )),
      ),
      // bottomNavigationBar: Obx(
      //   () => Get.find<DashboardController>().isShowKeyboard.isTrue
      //       ? Container(
      //           color: const Color(0xffeeeeee),
      //           child: VirtualKeyboard(
      //               focusNode: FocusNode(),
      //               textColor: Colors.black,
      //               type: Get.find<DashboardController>().isNumericMode
      //                   ? VirtualKeyboardType.Numeric
      //                   : VirtualKeyboardType.Alphanumeric,
      //               textController:
      //                   Get.find<DashboardController>().searchController),
      //         )
      //       : const SizedBox(),
      // )
    );
  }

  Future<bool> _willPopCallback() async {
    Get.toNamed('/dashboard');
    Get.find<DashboardController>().showProductDetails.value = false;
    return true; // return true if the route to be popped
  }
}
