import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:pos_system/views/dialogs/discount_dialog.dart';
import 'package:pos_system/views/dialogs/edit_qty_dialog.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/iconTextBox.dart';
import 'package:pos_system/views/pages/largePages/modals/checkout_modal.dart';
import 'package:pos_system/views/pages/largePages/modals/temp_orders_modal.dart';

import '../../../../dialogs/area_province_dialog.dart';
import '../../../../dialogs/customer_autocomplete_dialog.dart';
import '../../modals/refund_modal.dart';

class DashboardSidebar {
  Widget createSidebar() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder(builder: (CartController controller) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (Get.find<CartController>()
                        .addToCartList
                        .value
                        .where((element) => element.isSelected == true)
                        .toList()
                        .isEmpty) {
                      if (controller.addToCartList.value.isNotEmpty) {
                        Get.find<CartController>().removeAllFromCart(
                            tempUniqueId: Get.find<CartController>().uniqueId);
                      }
                    } else {
                      var item = Get.find<CartController>()
                          .addToCartList
                          .value
                          .where((element) => element.isSelected == true)
                          .first;
                      Get.find<CartController>().removeCartProductItem(
                          index: Get.find<CartController>()
                              .addToCartList
                              .value
                              .indexWhere(
                                  (element) => element.isSelected == true),
                          id: item.id.toString(),
                          tempUniqueId: Get.find<CartController>().uniqueId);
                    }
                  },
                  child: Container(
                    height: 60.0,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.close),
                            const SizedBox(
                              width: 4.0,
                            ),
                            CustomText().createText(
                              title: 'delete'.tr,
                              align: TextAlign.center,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (Get.find<CartController>()
                        .addToCartList
                        .value
                        .where((element) => element.isSelected == true)
                        .toList()
                        .isEmpty) {
                      Snack().createSnack(
                          title: 'Please Select An Item First',
                          msg: 'Your Shopping Cart is Empty',
                          bgColor: Colors.yellow,
                          msgColor: Colors.black,
                          titleColor: Colors.black);
                    } else {
                      EditQtyDialog.showCustomDialog(
                          title: 'Enter New Quantity',
                          productId: Get.find<CartController>()
                              .addToCartList
                              .value
                              .where((element) => element.isSelected == true)
                              .toList()
                              .first
                              .productId);
                    }
                  },
                  child: Container(
                    height: 60.0,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: CustomText().createText(
                          title: 'quantity'.tr,
                          align: TextAlign.center,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (controller.openCartsUDID.isNotEmpty) {
                      Get.bottomSheet(TempOrderModal(title: 'Temp Orders'),
                          isScrollControlled: true,
                          enableDrag: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ));
                    }
                  },
                  child: SizedBox(
                    height: 60,
                    child: FittedBox(
                      child: CustomText().createText(
                          title: controller.openCartsUDID.length.toString(),
                          align: TextAlign.center,
                          size: 20),
                    ),
                  ),
                )),
              ],
            ),
            const Divider(),
            Expanded(child: GetBuilder(builder: (CartController controller) {
              return ListView(
                children: [
                  ListView.separated(
                    itemCount:
                        Get.find<CartController>().addToCartList.value.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var currentItem =
                          Get.find<CartController>().addToCartList.value[index];
                      double itemQty =
                          double.parse(currentItem.quantity.toString());
                      double itemPrc =
                          double.parse(currentItem.price.toString());
                      double itemPrice = itemQty * itemPrc;
                      return GestureDetector(
                        onTap: () {
                          if (currentItem.isSelected == true) {
                            currentItem.isSelected = false;
                            controller.update();
                          } else {
                            if (controller.addToCartList.value
                                .where((element) => element.isSelected == true)
                                .toList()
                                .isNotEmpty) {
                              controller.addToCartList.value
                                  .where(
                                      (element) => element.isSelected == true)
                                  .first
                                  .isSelected = false;
                            }
                            currentItem.isSelected = true;
                            controller.update();
                          }
                        },
                        child: Container(
                          color: currentItem.isSelected == false
                              ? Colors.grey.withOpacity(0.1)
                              : Colors.green.withOpacity(0.3),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        CustomText()
                                            .createText(title: '#${index + 1}'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText().createText(title: ''),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        CustomText().createText(
                                            title: double.parse(currentItem
                                                    .price
                                                    .toString())
                                                .toStringAsFixed(3),
                                            fontWeight: FontWeight.bold),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText().createText(
                                            title: itemPrice.toStringAsFixed(3),
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
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ],
              );
            })),
            const Divider(),
            keyValText(
                title: 'Subtotal',
                value:
                    Get.find<CartController>().totalAmount.toStringAsFixed(3)),
            const SizedBox(
              height: 8,
            ),
            keyValText(
                title: 'Discount',
                value:
                    '- ${Get.find<CartController>().discountAmount.toStringAsFixed(3)}'),
            const SizedBox(
              height: 8,
            ),
            keyValText(
                title: 'Delivery',
                value:
                    '+ ${Get.find<CartController>().deliveryAmount.toStringAsFixed(3)}'),
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
                value: controller.isRefund.isFalse
                    ? (Get.find<CartController>().totalAmount -
                            Get.find<CartController>().discountAmount +
                            controller.deliveryAmount)
                        .toStringAsFixed(3)
                    : (Get.find<CartController>().totalAmount -
                            Get.find<CartController>().discountAmount)
                        .toStringAsFixed(3),
                keyWeight: FontWeight.bold,
                valWeight: FontWeight.bold,
                keySize: 22,
                valSize: 22),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: IconTextBox().createIconTextBox(
                      height: 80.0,
                      padding: const EdgeInsets.all(6),
                      icon: Icons.remove,
                      title: 'discount'.tr,
                      onTap: () {
                        if (controller.isRefund.isFalse) {
                          DiscountDialog.showCustomDialog(
                            title: 'Enter Discount Amount',
                          );
                        } else {
                          Snack().createSnack(
                              title: 'Warning',
                              msg: 'Can Not Using This Option On Refund Mode',
                              bgColor: Colors.yellow,
                              msgColor: Colors.black,
                              titleColor: Colors.black);
                        }
                      }),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: IconTextBox().createIconTextBox(
                      height: 80.0,
                      padding: const EdgeInsets.all(6),
                      icon: Icons.money,
                      title: 'cash_drawer'.tr,
                      onTap: () {
                        // Printer.connect('192.168.0.123', port: 9100)
                        //     .then((printer) async {
                        //   await printer.printQRCode('nhancv.com');
                        //   printer.println('');
                        //   printer.cut();
                        //   printer.openCashDrawer();
                        //   printer.disconnect();
                        // });
                      }),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: IconTextBox().createIconTextBox(
                      height: 80.0,
                      padding: const EdgeInsets.all(6),
                      icon: Icons.person,
                      title: 'customer'.tr,
                      onTap: () {
                        if (controller.isRefund.isFalse) {
                          if (Get.find<CustomerController>()
                              .customerList
                              .isNotEmpty) {
                            CustomerAutoCompleteDialog.showCustomDialog(
                                title: 'Customer',
                                list: Get.find<CustomerController>()
                                    .customerName);
                          } else {
                            Get.find<CustomerController>().getCustomers();
                          }
                        } else {
                          Snack().createSnack(
                              title: 'Warning',
                              msg: 'Can Not Using This Option On Refund Mode',
                              bgColor: Colors.yellow,
                              msgColor: Colors.black,
                              titleColor: Colors.black);
                        }
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Obx(() {
                  return Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          controller.calController.text = '';
                          controller.balanceStatus.value = '';
                          if (Get.find<CartController>()
                              .addToCartList
                              .value
                              .isNotEmpty) {
                            Get.bottomSheet(
                              controller.isRefund.isFalse
                                  ? CheckoutModal(title: 'Checkout')
                                  : RefundModal(
                                      title: 'Refund',
                                      total: (Get.find<CartController>()
                                                  .totalAmount -
                                              Get.find<CartController>()
                                                  .discountAmount)
                                          .toStringAsFixed(3),
                                      isWholeCart: controller
                                              .addToCartList.value.isNotEmpty
                                          ? false
                                          : true,
                                    ),
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            );
                          } else if (controller.addToCartList.value.isEmpty &&
                              controller.isRefund.isTrue) {
                            controller.calController.text = '';
                            //controller.refundCartTotalPrice;
                            Get.bottomSheet(
                              RefundModal(
                                title: 'Refund',
                                total: (Get.find<CartController>().totalAmount -
                                        Get.find<CartController>()
                                            .discountAmount)
                                    .toStringAsFixed(3),
                                isWholeCart: true,
                              ),
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              color: controller.isRefund.isFalse
                                  ? Colors.green
                                  : Colors.red,
                              border: Border.all(
                                  color: Colors.green.withOpacity(0.5),
                                  width: 2)),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText().createText(
                                      title: 'F10'.tr,
                                      color: Colors.white,
                                      align: TextAlign.center,
                                      size: 22,
                                      fontWeight: FontWeight.bold),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  CustomText().createText(
                                    title: controller.isRefund.isFalse
                                        ? 'payment'.tr
                                        : 'Refund',
                                    color: Colors.white,
                                    align: TextAlign.center,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                }),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: IconTextBox().createIconTextBox(
                      height: 80.0,
                      padding: const EdgeInsets.all(6),
                      icon: Icons.delivery_dining,
                      title: 'delivery'.tr,
                      onTap: () {
                        if (controller.isRefund.isFalse) {
                          if (Get.find<CartController>()
                              .countryList
                              .isNotEmpty) {
                            AreaProvinceDialog.showCustomDialog(
                                title: 'Province & Areas');
                          } else {
                            Get.find<CartController>().getAreas();
                          }
                        } else {
                          Snack().createSnack(
                              title: 'Warning',
                              msg: 'Can Not Using This Option On Refund Mode',
                              bgColor: Colors.yellow,
                              msgColor: Colors.black,
                              titleColor: Colors.black);
                        }
                      }),
                ),
              ],
            ),
          ],
        );
      }),
    );
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
