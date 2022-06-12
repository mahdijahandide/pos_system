import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/model/product_size_model.dart';
import 'package:pos_system/views/components/texts/customText.dart';

import '../components/snackbar/snackbar.dart';

class ProductOptionDialog1 {
  static final ProductOptionDialog1 _instance = ProductOptionDialog1.internal();

  ProductOptionDialog1.internal();

  factory ProductOptionDialog1() => _instance;

  static void showCustomDialog({required title, required productId}) {
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Container(
          width: Get.width / 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: DropdownButton<String>(
            isExpanded: true,
            focusColor: Colors.white,
            hint:
                Text(Get.find<ProductController>().selectedSizeName.toString()),
            onChanged: (val) {
              Get.find<ProductController>().selectedSizeId = val.toString();
              Get.find<ProductController>().selectedSizeName.value =
                  Get.find<ProductController>()
                      .productSizeList
                      .where((element) =>
                          element.sizeId == int.parse(val.toString()))
                      .first
                      .sizeName!;
              controller.update();
            },
            items: Get.find<ProductController>()
                .productSizeList
                .map((ProductSizeModel value) {
              return DropdownMenuItem<String>(
                value: value.sizeId.toString(),
                child: Text(value.sizeName.toString()),
              );
            }).toList(),
          ),
        );
      }),
      contentPadding: const EdgeInsets.all(15),
      confirm: InkWell(
          onTap: () {
            var current = Get.find<ProductController>()
                .productList
                .value
                .where(
                    (element) => element.id == int.parse(productId.toString()))
                .toList()[0];
            if (int.parse(current.quantity.toString()) > 0) {
              Get.find<CartController>().addToCart(
                  title: current.title,
                  openDialog: true,
                  productId: current.id.toString(),
                  optionSc: '1',
                  price: current.retailPrice.toString(),
                  quantity: '1',
                  tempUniqueId: Get.find<CartController>().uniqueId.toString(),
                  sizeAttribute:
                      Get.find<ProductController>().selectedSizeId.toString());
            } else {
              Snack().createSnack(
                  title: 'warning',
                  msg: 'No enough quantity',
                  bgColor: Colors.yellow,
                  msgColor: Colors.black,
                  titleColor: Colors.black);
            }
          },
          child: Container(
            width: 90,
            height: 50,
            alignment: Alignment.center,
            color: Colors.green.withOpacity(0.2),
            child: CustomText().createText(title: 'Submit', color: Colors.teal),
          )),
      cancel: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
              width: 90,
              height: 50,
              alignment: Alignment.center,
              color: Colors.red.withOpacity(0.2),
              child:
                  CustomText().createText(title: 'Cancel', color: Colors.red))),
    );
  }
}
