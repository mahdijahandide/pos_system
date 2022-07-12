import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/model/product_color_model.dart';
import 'package:pos_system/services/model/product_size_color_model.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class ProductOptionDialog3 {
  static final ProductOptionDialog3 _instance = ProductOptionDialog3.internal();

  ProductOptionDialog3.internal();

  factory ProductOptionDialog3() => _instance;

  static void showCustomDialog({required title, required productId}) {
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Container(
          width: Get.width / 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            children: [
              //size
              DropdownButton<String>(
                isExpanded: true,
                focusColor: Colors.white,
                hint: Text(
                    Get.find<ProductController>().selectedSizeName.toString()),
                onChanged: (val) {
                  Get.find<ProductController>().selectedSizeId = val.toString();
                  Get.find<ProductController>().selectedSizeName.value =
                      Get.find<ProductController>()
                          .productSizeColorList
                          .where((element) =>
                              element.sizeId == int.parse(val.toString()))
                          .first
                          .sizeName!;
                  controller.update();
                },
                items: Get.find<ProductController>()
                    .productSizeColorList
                    .map((ProductSizeColorModel value) {
                  return DropdownMenuItem<String>(
                    value: value.sizeId.toString(),
                    child: Text(value.sizeName.toString()),
                  );
                }).toList(),
              ),
              //color
              Get.find<ProductController>().selectedSizeId == ''
                  ? const SizedBox()
                  : DropdownButton<String>(
                      isExpanded: true,
                      focusColor: Colors.white,
                      hint: Text(Get.find<ProductController>()
                          .selectedColorName
                          .toString()),
                      onChanged: (val) {
                        Get.find<ProductController>().selectedColorId =
                            val.toString();
                        Get.find<ProductController>().selectedColorName.value =
                            Get.find<ProductController>()
                                .productSizeColorList
                                .where((element) =>
                                    element.sizeName ==
                                    Get.find<ProductController>()
                                        .selectedSizeName
                                        .value)
                                .first
                                .colorList
                                .where((element) =>
                                    element.colorId ==
                                    int.parse(val.toString()))
                                .first
                                .colorName
                                .toString();
                        controller.update();
                      },
                      items: Get.find<ProductController>()
                          .productSizeColorList
                          .where((element) =>
                              element.sizeName ==
                              Get.find<ProductController>()
                                  .selectedSizeName
                                  .toString())
                          .first
                          .colorList
                          .map((ProductColorModel value) {
                        return DropdownMenuItem<String>(
                          value: value.colorId.toString(),
                          child: Text(value.colorName.toString()),
                        );
                      }).toList(),
                    ),
            ],
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
                  optionSc: '3',
                  productId: current.id.toString(),
                  price: current.retailPrice.toString(),
                  quantity: '1',
                  tempUniqueId: Get.find<CartController>().uniqueId.toString(),
                  sizeAttribute:
                      Get.find<ProductController>().selectedSizeId.toString(),
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
              child: CustomText()
                  .createText(title: 'Submit', color: Colors.teal))),
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
