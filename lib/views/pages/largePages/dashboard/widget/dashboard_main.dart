import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/category_widget.dart';

class DashboardMain {
  Widget createMain(
      {required gridCnt,
      dynamic key,
      dynamic isLarge,
      dynamic noSideBar,
      dynamic ontap}) {
    return GetBuilder(builder: (DashboardController controller) {
      return Column(
        children: [
          IntrinsicHeight(
            child: isLarge == true
                ? Row(
                    children: [
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      // InkWell(
                      //     onTap: () => controller.changeSearchType(id: 1),
                      //     child: Icon(
                      //       Icons.qr_code_scanner,
                      //       size: 45,
                      //       color: controller.searchId.value.isEqual(1)
                      //           ? Colors.blue
                      //           : Colors.black,
                      //     )),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      // const VerticalDivider(),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      // InkWell(
                      //     onTap: () => controller.changeSearchType(id: 2),
                      //     child: CustomText().createText(
                      //       title: '123',
                      //       fontWeight: FontWeight.bold,
                      //       size: 20,
                      //       color: controller.searchId.value.isEqual(2)
                      //           ? Colors.blue
                      //           : Colors.black,
                      //     )),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      // const VerticalDivider(),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      // InkWell(
                      //     onTap: () => controller.changeSearchType(id: 3),
                      //     child: Icon(
                      //       Icons.label,
                      //       size: 45,
                      //       color: controller.searchId.value.isEqual(3)
                      //           ? Colors.blue
                      //           : Colors.black,
                      //     )),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      // const VerticalDivider(),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                          child: CustomTextField().createTextField(
                              hint: 'Search anything...',
                              // controller.searchId.value.isEqual(1)
                              //     ? 'search product by barcode'
                              //     : controller.searchId.value.isEqual(3)
                              //         ? 'search product by name'
                              //         : 'search product by code',
                              onSubmitted: (_) async {
                                LoadingDialog.showCustomDialog(
                                    msg: 'Loading ...');
                                Get.find<ProductController>().getAllProducts(
                                    openModal: true,
                                    openModalTap: ontap,
                                    title: controller.searchController.text
                                        .toString(),
                                    keyword: controller.searchController.text
                                        .toString(),
                                    catId: '');
                              },
                              controller: Get.find<DashboardController>()
                                  .searchController,
                              height: 60.0,
                              align: TextAlign.start,
                              suffixPress: () {
                                LoadingDialog.showCustomDialog(
                                    msg: 'Loading ...');
                                Get.find<ProductController>().getAllProducts(
                                    openModal: true,
                                    openModalTap: ontap,
                                    title: controller.searchController.text
                                        .toString(),
                                    keyword: controller.searchController.text
                                        .toString(),
                                    catId: '');
                              },
                              hasSuffixIcon: true)),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                          onTap: () {
                            controller.isShowKeyboard.value =
                                !controller.isShowKeyboard.value;
                            controller.update();
                          },
                          child: Icon(Icons.keyboard,
                              size: 45,
                              color: controller.isShowKeyboard.isTrue
                                  ? Colors.blue
                                  : Colors.black)),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const SizedBox(
                        width: 3,
                      ),
                      noSideBar == true
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                key.currentState!.openDrawer();
                              },
                              child: const Icon(
                                Icons.menu,
                                size: 30,
                              )),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                          child: CustomTextField().createTextField(
                        hint: 'Search anything ...',
                        onSubmitted: (_) async {
                          LoadingDialog.showCustomDialog(msg: 'Loading ...');
                          Get.find<ProductController>().getAllProducts(
                              openModal: true,
                              openModalTap: ontap,
                              title:
                                  controller.searchController.text.toString(),
                              keyword:
                                  controller.searchController.text.toString(),
                              catId: '');
                        },
                        controller:
                            Get.find<DashboardController>().searchController,
                        height: 60.0,
                        align: TextAlign.start,
                        suffixPress: () {
                          LoadingDialog.showCustomDialog(msg: 'Loading ...');
                          Get.find<ProductController>().getAllProducts(
                              openModal: true,
                              openModalTap: ontap,
                              title:
                                  controller.searchController.text.toString(),
                              keyword:
                                  controller.searchController.text.toString(),
                              catId: '');
                          controller.searchController.clear();
                          controller.update();
                        },
                        hasSuffixIcon: true,
                      )),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
          ),
          const Divider(),
          const SizedBox(
            height: 4,
          ),
          CategoryWidget(
            ontap: ontap,
          ),
          const SizedBox(
            height: 14,
          ),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCnt,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: Get.find<ProductController>().productList.value.length,
              itemBuilder: (context, index) {
                var currentItem =
                    Get.find<ProductController>().productList.value[index];
                return GestureDetector(
                  onTap: ontap == true
                      ? () {
                          Get.find<ProductController>().getProductDetails(
                              productId: currentItem.id, showDetails: true);
                        }
                      : () {
                          if (currentItem.isAttribute == 0) {
                            bool contain = Get.find<CartController>()
                                .addToCartList
                                .value
                                .where((element) =>
                                    element.productId.toString() ==
                                    currentItem.id.toString())
                                .isEmpty;

                            if (contain) {
                              if (Get.isSnackbarOpen) {
                                Get.closeCurrentSnackbar();
                              }
                              if (int.parse(currentItem.quantity.toString()) >
                                  0) {
                                if (Get.find<CartController>()
                                    .isRefund
                                    .isFalse) {
                                  Get.find<CartController>().addToCart(
                                      optionSc: '0',
                                      productId: currentItem.id.toString(),
                                      price: currentItem.retailPrice.toString(),
                                      quantity: '1',
                                      title: currentItem.title,
                                      titleAr: currentItem.titleAr.toString(),
                                      tempUniqueId: Get.find<CartController>()
                                          .uniqueId
                                          .toString());
                                } else {
                                  var product = Get.find<CartController>()
                                      .refundFactorItemList
                                      .value
                                      .where((product) =>
                                          product.productId.toString() ==
                                          currentItem.id.toString())
                                      .first
                                      .productId
                                      .toString();

                                  final index = Get.find<CartController>()
                                      .addToCartList
                                      .value
                                      .indexWhere((element) =>
                                          element.productId.toString() ==
                                          product);

                                  if (product == currentItem.id.toString()) {
                                    if (index < 0) {
                                      Get.find<CartController>().addToCart(
                                          optionSc: '0',
                                          productId: currentItem.id.toString(),
                                          price: currentItem.retailPrice
                                              .toString(),
                                          quantity: '1',
                                          title: currentItem.title,
                                          titleAr:
                                              currentItem.titleAr.toString(),
                                          tempUniqueId:
                                              Get.find<CartController>()
                                                  .uniqueId
                                                  .toString());
                                    } else {
                                      Snack().createSnack(
                                          title: 'warning',
                                          msg: 'item exist in cart',
                                          bgColor: Colors.yellow,
                                          msgColor: Colors.black,
                                          titleColor: Colors.black);
                                    }
                                  } else {
                                    Snack().createSnack(
                                        title: 'warning',
                                        msg: 'No enough quantity',
                                        bgColor: Colors.yellow,
                                        msgColor: Colors.black,
                                        titleColor: Colors.black);
                                  }
                                }
                              } else {
                                Snack().createSnack(
                                    title: 'warning',
                                    msg: 'No enough quantity',
                                    bgColor: Colors.yellow,
                                    msgColor: Colors.black,
                                    titleColor: Colors.black);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "this item already exist in your cart", // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.CENTER, // location
                                  webPosition: 'center',
                                  timeInSecForIosWeb: 2 // duration
                                  );
                            }
                          } else {
                            bool contain = Get.find<CartController>()
                                .addToCartList
                                .value
                                .where((element) =>
                                    element.productId.toString() ==
                                    currentItem.id.toString())
                                .isEmpty;
                            if (contain) {
                              if (int.parse(currentItem.quantity.toString()) >
                                  0) {
                                if (Get.find<CartController>()
                                    .isRefund
                                    .isFalse) {
                                  Get.find<ProductController>()
                                      .getProductDetails(
                                          productId: currentItem.id.toString(),
                                          title: currentItem.title);
                                } else {
                                  var product = Get.find<CartController>()
                                      .refundFactorItemList
                                      .value
                                      .where((product) =>
                                          product.productId.toString() ==
                                          currentItem.id.toString())
                                      .first
                                      .productId
                                      .toString();

                                  final index = Get.find<CartController>()
                                      .addToCartList
                                      .value
                                      .indexWhere((element) =>
                                          element.productId.toString() ==
                                          product);

                                  if (product == currentItem.id.toString()) {
                                    if (index < 0) {
                                      Get.find<ProductController>()
                                          .getProductDetails(
                                              productId:
                                                  currentItem.id.toString(),
                                              title: currentItem.title);
                                    } else {
                                      Snack().createSnack(
                                          title: 'warning',
                                          msg: 'item exist in cart',
                                          bgColor: Colors.yellow,
                                          msgColor: Colors.black,
                                          titleColor: Colors.black);
                                    }
                                  } else {
                                    Snack().createSnack(
                                        title: 'warning',
                                        msg: 'No enough quantity',
                                        bgColor: Colors.yellow,
                                        msgColor: Colors.black,
                                        titleColor: Colors.black);
                                  }
                                }
                              } else {
                                Snack().createSnack(
                                    title: 'warning',
                                    msg: 'No enough quantity',
                                    bgColor: Colors.yellow,
                                    msgColor: Colors.black,
                                    titleColor: Colors.black);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "this item already exist in your cart", // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.CENTER, // location
                                  webPosition: 'center',
                                  timeInSecForIosWeb: 2 // duration
                                  );
                            }
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5), width: 1.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Image(
                          image: NetworkImage('${currentItem.image}'),
                        )),
                        const SizedBox(
                          height: 15,
                        ),
                        FittedBox(
                          child: CustomText().createText(
                              title: currentItem.title,
                              fontWeight: FontWeight.bold,
                              align: TextAlign.center,
                              size: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText().createText(
                            title: currentItem.retailPrice.toString() + ' KD',
                            fontWeight: FontWeight.bold,
                            size: 14),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget keyValText(
      {required title,
      required value,
      dynamic keyWeight,
      dynamic valWeight,
      dynamic keySize,
      dynamic valSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: FittedBox(
                child: CustomText().createText(
                    title: title,
                    size: keySize ?? 16,
                    fontWeight: keyWeight ?? FontWeight.normal))),
        const SizedBox(
          width: 12,
        ),
        Flexible(
            child: FittedBox(
                child: CustomText().createText(
                    title: value,
                    size: valSize ?? 16,
                    fontWeight: valWeight ?? FontWeight.normal))),
      ],
    );
  }
}
