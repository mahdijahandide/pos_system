import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/model/product_color_model.dart';
import 'package:pos_system/views/components/texts/customText.dart';

import '../components/snackbar/snackbar.dart';

class ProductOptionDialog2 {
  static final ProductOptionDialog2 _instance = ProductOptionDialog2.internal();

  ProductOptionDialog2.internal();

  factory ProductOptionDialog2() => _instance;

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
            hint: Text(
                Get.find<ProductController>().selectedColorName.toString()),
            onChanged: (val) {
              Get.find<ProductController>().selectedColorId = val.toString();
              Get.find<ProductController>().selectedColorName.value =
                  Get.find<ProductController>()
                      .productColorList
                      .where((element) =>
                          element.colorId == int.parse(val.toString()))
                      .first
                      .colorName!;
              controller.update();
            },
            items: Get.find<ProductController>()
                .productColorList
                .map((ProductColorModel value) {
              return DropdownMenuItem<String>(
                value: value.colorId.toString(),
                child: Text(value.colorName.toString()),
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
                  iCode: current.itemCode.toString(),
                  title: current.title,
                  titleAr: current.titleAr.toString(),
                  openDialog: true,
                  optionSc: '2',
                  productId: current.id.toString(),
                  price: current.retailPrice.toString(),
                  quantity: '1',
                  tempUniqueId: Get.find<CartController>().uniqueId.toString(),
                  colorAttribute:
                      Get.find<ProductController>().selectedColorId.toString());
            } else {
              Snack().createSnack(
                  title: 'Warning',
                  msg: 'No Enough Quantity',
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
            Get.back(closeOverlays: true, canPop: true);
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
