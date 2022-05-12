import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/helper/app_color.dart';
import 'package:pos_system/services/controller/category_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:pos_system/views/pages/largePages/products/products_modal.dart';
import 'package:shimmer/shimmer.dart';

class CategoryWidget extends StatelessWidget {
  final Function(String)? onItemClick;
var ontap;
   CategoryWidget({Key? key, this.onItemClick, this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Get.find<CategoryController>().hasCategory.isFalse
          ? Container(
              alignment: Alignment.center,
              height: 100,
              child: ListView.builder(
                  itemCount: 30,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Shimmer.fromColors(
                      highlightColor: AppColor.SHIMMER_FG,
                      baseColor: AppColor.SHIMMER_BG,
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(1, 2),
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
                        child: Center(
                          child: CustomText()
                              .createText(title: 'currentItem.titleEn'),
                        ),
                      ),
                    );
                  }),
            )
          : Container(
              alignment: Alignment.center,
              height: 100,
              child: ListView.builder(
                  itemCount: Get.find<CategoryController>().categoryList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    var currentItem =
                        Get.find<CategoryController>().categoryList[index];
                    return InkWell(
                      onTap: () {
                        if (currentItem.subCategory.isNotEmpty) {
                          Get.bottomSheet(
                            ProductsModal(
                                gridCnt: Get.width < 600
                                    ? 2
                                    : Get.width > 600 && Get.width < 900
                                        ? 3
                                        : 5,
                                title: currentItem.title.toString(),
                                current: currentItem.subCategory,ontap: ontap,
                                listCount: currentItem.subCategory.length),
                            isScrollControlled: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          );
                        } else {
                          LoadingDialog.showCustomDialog(msg: 'Loading ...');
                          Get.find<ProductController>().getAllProducts(openModalTap: ontap,
                              catId: currentItem.id.toString(),
                              keyword: '',
                              openModal: true,
                              title: currentItem.title);
                        }
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(1, 2),
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
                        child: Center(
                          child: CustomText().createText(
                              title: currentItem.title,
                              align: TextAlign.center),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
