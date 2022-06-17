import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:web_date_picker/web_date_picker.dart';
import '../../../components/texts/customText.dart';
import 'package:intl/intl.dart';

class SaleHistory extends GetView<OrderController> {
  const SaleHistory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OrderController());
    if (controller.hasList.isFalse) {
      controller.getOrders();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: 'Sale History'.tr, size: 18, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'Select Date',
                    cancel: InkWell(
                      onTap: () {
                        controller.orderFilteredList.value =
                            controller.orderList.value;
                        controller.selectedFilteredDate.value = '';
                        Get.back();
                      },
                      child: Container(
                        width: 90,
                        height: 50,
                        alignment: Alignment.center,
                        color: Colors.red.withOpacity(0.2),
                        child: CustomText().createText(
                            title: 'Remove Filter', color: Colors.red),
                      ),
                    ),
                    content: WebDatePicker(
                      dateformat: 'yyyy-MM-dd',
                      initialDate: controller
                              .selectedFilteredDate.value.isNotEmpty
                          ? DateTime.parse(
                              controller.selectedFilteredDate.value.toString())
                          : DateTime.now(),
                      onChange: (value) {
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        RxString date = formatter.format(value!).obs;
                        controller.orderFilteredList.value = controller
                            .orderList.value
                            .where((element) =>
                                element.deliveryDate.toString() == date.value)
                            .toList();
                        controller.selectedFilteredDate.value =
                            value.toString();
                        Get.back();
                      },
                    ));
              },
              icon: const Icon(Icons.sort))
        ],
      ),
      body: Obx(() {
        return controller.hasList.isFalse
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.orderFilteredList.value.length,
                itemBuilder: (context, index) {
                  var currentItem = controller.orderFilteredList.value[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12.withOpacity(0.5),
                              offset: const Offset(1, 3),
                              blurRadius: 3,
                              spreadRadius: 1)
                        ]),
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: Get.width,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: currentItem.orderStatus ==
                                                  'returned'
                                              ? Colors.red
                                              : Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                          child: CustomText().createText(
                                              title: currentItem.orderStatus
                                                  .toString(),
                                              align: TextAlign.center,
                                              color: Colors.white,
                                              size: 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    CustomText().createText(
                                        title:
                                            currentItem.totalAmount.toString() +
                                                ' KD',
                                        size: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ],
                                ),
                                CustomText().createText(
                                    title: currentItem.deliveryDate.toString(),
                                    size: 22,
                                    color: Colors.black),
                                InkWell(
                                    onTap: () {
                                      Get.find<CartController>()
                                              .printedFactorId
                                              .value =
                                          currentItem.orderId.toString();
                                      controller.getOrderProducts(
                                          id: currentItem.id,
                                          current: currentItem,
                                          showModal: true);
                                    },
                                    child: CustomText().createText(
                                        title: 'ID : ${currentItem.orderId} ',
                                        size: 22,
                                        color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                        ExpansionTile(
                          textColor: Colors.black12,
                          trailing: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.black,
                          ),
                          title: ListTile(
                            title: CustomText().createText(
                                title: 'Show Details',
                                size: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText().createText(
                                            title: currentItem.name.toString(),
                                            size: 18,
                                          ),
                                          CustomText().createText(
                                            title:
                                                currentItem.mobile.toString(),
                                            size: 18,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //   CustomText().createText(title: 'Remark',size: 18,),
                                  //   CustomText().createText(title: 'Consultation Fees',size: 18,),
                                  // ],)
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
      }),
    );
  }
}
