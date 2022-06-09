import 'dart:async';
import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/remotes/local_storage.dart';

import '../../../../services/controller/cart_controller.dart';
import '../../../../services/model/cart_product_model.dart';
import '../../../components/texts/customText.dart';


class ShowFactor extends StatelessWidget {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    CartController controller=Get.put(CartController());
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _refresh());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder(builder:(CartController controller) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              ListView.separated(
                itemCount: Get
                    .find<CartController>()
                    .addToCartList
                    .value
                    .length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var currentItem =
                  Get
                      .find<CartController>()
                      .addToCartList
                      .value[index];
                  double itemQty =
                  double.parse(currentItem.quantity.toString());
                  double itemPrc =
                  double.parse(currentItem.price.toString());
                  double itemPrice = itemQty * itemPrc;
                  return Container(
                    color:
                    Colors.grey.withOpacity(0.1),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: CustomText().createText(
                                    title: currentItem.title,
                                    fontWeight: FontWeight.bold,
                                    size: 18),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  CustomText().createText(
                                      title: '#${index + 1}'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomText().createText(title: ''),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  CustomText().createText(
                                      title: '${currentItem.price}',
                                      fontWeight: FontWeight.bold),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomText().createText(
                                      title: itemPrice.toString(),
                                      fontWeight: FontWeight.bold),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerEnd,
                            child: CustomText().createText(
                                title: currentItem.quantity,
                                size: 16,
                                fontWeight: FontWeight.bold,
                                align: TextAlign.end))
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
              const Divider(),
              keyValText(
                  title: 'Subtotal',
                  value: Get
                      .find<CartController>()
                      .totalAmount
                      .toString()),
              const SizedBox(
                height: 8,
              ),
              keyValText(
                  title: 'Discount',
                  value:
                  '- ${Get
                      .find<CartController>()
                      .discountAmount
                      .toString()}'),
              const SizedBox(
                height: 8,
              ),
              keyValText(
                  title: 'Delivery',
                  value:
                  '+ ${Get
                      .find<CartController>()
                      .deliveryAmount
                      .toString()}'),
              const SizedBox(
                height: 8,
              ),
              const DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 1.2,
                dashLength: 5.0,
                dashColor: Colors.grey,
                dashRadius: 0.0,
                dashGapLength: 4.0,
                dashGapColor: Colors.transparent,
                dashGapRadius: 0.0,
              ),
              const SizedBox(
                height: 12,
              ),
              keyValText(
                  title: 'total'.tr,
                  value: (Get
                      .find<CartController>()
                      .totalAmount +
                      Get
                          .find<CartController>()
                          .deliveryAmount -
                      Get
                          .find<CartController>()
                          .discountAmount)
                      .toString(),
                  keyWeight: FontWeight.bold,
                  valWeight: FontWeight.bold,
                  keySize: 22,
                  valSize: 22),
              const Divider(),
            ],
          ),
        );
      }),
    );
  }

  Widget keyValText({required title,
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

  void _refresh() {
    var data = jsonDecode(LocalStorageHelper.getValue('cartData'));
    Get
        .find<CartController>()
        .addToCartList
        .value
        .clear();
    data['data'].forEach((element) {
      Get
          .find<CartController>()
          .addToCartList
          .value
          .add(CartProductModel(mId: element['id'],
          pId: element['productId'],
          mPrice: element['price'],
          mQuantity: element['quantity'],
          mTitle: element['title'],
          mTempUniqueId: element['tempUniqueId'], mTitleAr: element['title']));
    });
    Get.find<CartController>().totalAmount=double.parse(data['subTotal'].toString());
    Get.find<CartController>().discountAmount=double.parse(data['discount'].toString());
    Get.find<CartController>().deliveryAmount=double.parse(data['delivery'].toString());
    Get.find<CartController>().update();
  }
}
