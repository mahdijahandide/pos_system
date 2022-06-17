import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';

import '../../../../services/controller/product_controller.dart';

class TempOrderModal extends StatelessWidget {
  String title;
  TempOrderModal({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GetBuilder(builder: (CartController cartController) {
          return Container(
            color: Colors.white,
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              Container(
                width: Get.width,
                color: Colors.grey.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    CustomText().createText(
                        title: title,
                        size: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 23,
                        ))
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartController.openCartsUDID.length,
                itemBuilder: (context, index) {
                  var currentItem = cartController.openCartsUDID[index];
                  return InkWell(
                    onTap: () {
                      cartController.newSale();
                      if (Get.find<CartController>().isRefund.isTrue) {
                        Get.find<CartController>().isRefund.value = false;
                        Get.find<ProductController>().productList.value.clear();
                        Get.find<ProductController>()
                            .getAllProducts(catId: '', keyword: '');
                      }

                      cartController.getTempOrders(
                          cartId: currentItem.tempId, index: index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12.withOpacity(0.5),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                                spreadRadius: 1)
                          ]),
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: Get.width,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText().createText(
                                          title: 'CartNo: ${index + 1}',
                                          size: 22,
                                          color: Colors.black),
                                      CustomText().createText(
                                          title: currentItem.tempTime,
                                          size: 22,
                                          color: Colors.black),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cartController.openCartsUDID
                                          .removeAt(index);
                                      cartController.update();
                                      if (cartController
                                          .openCartsUDID.isEmpty) {
                                        Get.back(closeOverlays: true);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ]),
          );
        }));
  }
}
