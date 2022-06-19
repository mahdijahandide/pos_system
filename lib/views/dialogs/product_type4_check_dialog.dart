import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect/multiselect.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class ProductTypeCheck {
  static final ProductTypeCheck _instance = ProductTypeCheck.internal();

  ProductTypeCheck.internal();

  factory ProductTypeCheck() => _instance;

  static void showCustomDialog(
      {required title,
      required productId,
      required type,
      required isRequired,
      required otherId}) {
    List<String> selected = [];
    List<String> options = [];
    for (int i = 0;
        i < Get.find<ProductController>().productOthersList.length;
        i++) {
      options.add(
          Get.find<ProductController>().productOthersList[i].title.toString());
    }
    Get.defaultDialog(
      title: title,
      content: GetBuilder(builder: (ProductController controller) {
        return Container(
          width: Get.width / 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: DropDownMultiSelect(
            onChanged: (List<String> x) {
              selected = x;
              print(selected);
            },
            options: options,
            selectedValues: selected,
            whenEmpty: 'Select values',
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
