import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';

import '../../../components/snackbar/snackbar.dart';

class ProductsModal extends StatelessWidget {
  int gridCnt;
  String title;
  var isProduct;
  var current;
  var listCount;
  var ontap;
  ProductsModal(
      {Key? key,
      required this.gridCnt,
      this.isProduct,
      required this.title,
      required this.current,
      required this.listCount,
      this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProductController>().overlaysCounter.value++;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.only(top: 80),
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  CustomText().createText(
                      title: title, size: 18, fontWeight: FontWeight.bold),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 23,
                      )),
                ],
              ),
              const SizedBox(
                height: 12,
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
                  itemCount: listCount,

                  // Get.find<CategoryController>().categoryProductList.length,
                  itemBuilder: (context, index) {
                    var currentItem = current[index];
                    // Get.find<CategoryController>().categoryProductList[index];
                    return GestureDetector(
                      onTap: () {
                        if (isProduct == true) {
                          if (ontap == true ||
                              Get.find<DashboardController>()
                                  .showProductDetails
                                  .isTrue) {
                            Get.find<ProductController>().getProductDetails(
                                productId: currentItem.id, showDetails: true);
                          } else if (currentItem.isAttribute == 0) {
                            bool contain = Get.find<CartController>()
                                .addToCartList
                                .value
                                .where((element) =>
                                    element.productId.toString() ==
                                    currentItem.id.toString())
                                .isEmpty;
                            if (contain) {
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
                              Get.back(closeOverlays: true);
                              // Fluttertoast.showToast(
                              //     msg:
                              //         "this item already exist in your cart", // message
                              //     toastLength: Toast.LENGTH_SHORT, // length
                              //     gravity: ToastGravity.CENTER, // location
                              //     webPosition: 'center',
                              //     timeInSecForIosWeb: 2 // duration
                              //     );
                              Snack().createSnack(
                                  title: 'Warning',
                                  msg: 'This Item Already Exist In Your Cart',
                                  bgColor: Colors.green,
                                  msgColor: Colors.black,
                                  titleColor: Colors.black,
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ));
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
                              Get.find<ProductController>().getProductDetails(
                                  productId: currentItem.id.toString(),
                                  title: currentItem.title);
                            } else {
                              Get.back(closeOverlays: true);
                              // Fluttertoast.showToast(
                              //     msg:
                              //         "this item already exist in your cart", // message
                              //     toastLength: Toast.LENGTH_SHORT, // length
                              //     gravity: ToastGravity.CENTER, // location
                              //     webPosition: 'center',
                              //     timeInSecForIosWeb: 2 // duration
                              //     );
                              Snack().createSnack(
                                  title: 'Warning',
                                  msg: 'This Item Already Exist In Your Cart',
                                  bgColor: Colors.green,
                                  msgColor: Colors.black,
                                  titleColor: Colors.black,
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ));
                            }
                          }
                        } else {
                          if (currentItem.subCategory.isNotEmpty) {
                            Get.bottomSheet(
                              ProductsModal(
                                  gridCnt: Get.width < 600
                                      ? 2
                                      : Get.width > 600 && Get.width < 900
                                          ? 3
                                          : 5,
                                  title: currentItem.title.toString(),
                                  current: currentItem.subCategory,
                                  listCount: currentItem.subCategory.length),
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            );
                          } else {
                            LoadingDialog.showCustomDialog(msg: 'Loading ...');
                            Get.find<ProductController>().getAllProducts(
                                catId: currentItem.id.toString(),
                                keyword: '',
                                openModal: true,
                                title: currentItem.title);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Image(
                              image: NetworkImage(currentItem.image),
                            )),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomText().createText(
                                title: currentItem.title,
                                fontWeight: FontWeight.bold,
                                align: TextAlign.center,
                                size: 18),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // CustomText().createText(
                            //     title: currentItem.title.toString() + ' KD',
                            //     fontWeight: FontWeight.bold,
                            //     size: 14),
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
          ),
        ));
  }
}
