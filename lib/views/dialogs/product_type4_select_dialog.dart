import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/model/product_others_model.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class ProductTypeSelect {
  static final ProductTypeSelect _instance = ProductTypeSelect.internal();

  ProductTypeSelect.internal();

  factory ProductTypeSelect() => _instance;

  static void showCustomDialog(
      {required title,
      required productId,
      required type,
      required isRequired,
      required otherId}) {
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Container(
          width: Get.width / 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: DropdownButton<String>(
            isExpanded: true,
            focusColor: Colors.white,
            hint: Text(Get.find<ProductController>().selectedValue.toString()),
            onChanged: (val) {
              Get.find<ProductController>().selectedValueId = val.toString();
              Get.find<ProductController>().selectedValue.value =
                  Get.find<ProductController>()
                      .productOthersList
                      .where(
                          (element) => element.id == int.parse(val.toString()))
                      .first
                      .title!;
              controller.update();
            },
            items: Get.find<ProductController>()
                .productOthersList
                .map((ProductOthersModel value) {
              return DropdownMenuItem<String>(
                value: value.id.toString(),
                child: Text(value.title.toString()),
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
                  titleAr: current.titleAr.toString(),
                  openDialog: true,
                  optionSc: '4',
                  productId: current.id.toString(),
                  price: Get.find<ProductController>()
                      .productOthersList
                      .where((element) =>
                          element.id.toString() ==
                          Get.find<ProductController>()
                              .selectedValueId
                              .toString())
                      .first
                      .retail_price
                      .toString(),
                  quantity: '1',
                  otherAttribute: true,
                  tempUniqueId: Get.find<CartController>().uniqueId.toString(),
                  otherValue: Get.find<ProductController>().selectedValueId,
                  otherId: otherId);
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
