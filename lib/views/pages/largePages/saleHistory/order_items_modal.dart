import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:pos_system/views/pages/largePages/saleHistory/printing_history_view.dart';
import 'package:printing/printing.dart';

import '../../../components/texts/customText.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class OrderItemsModal {
  Widget orderItems() {
    return Container(
      color: Colors.white,
      child: ListView(physics: const BouncingScrollPhysics(), children: [
        Container(
          width: Get.width,
          color: Colors.grey.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    // await for (var page in Printing.raster(await PrintingHistoryView().generatePdf().save(),
                    //     pages: [0, 1], dpi: 72)) {
                    //   final image = page.toImage(); // ...or page.toPng()
                    //   print(image);
                    // }
                    // Get.toNamed('/print');
                    await Printing.layoutPdf(
                      onLayout: (_) => PrintingHistoryView().generatePdf(),
                    );
                  },
                  icon: const Icon(Icons.print)),
              CustomText().createText(
                  title: 'Order Items',
                  size: 18,
                  color: Colors.white,
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
          itemCount: Get.find<OrderController>().orderItemsList.length,
          itemBuilder: (context, index) {
            var currentItem = Get.find<OrderController>().orderItemsList[index];
            return Container(
                width: Get.width,
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
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                              image: NetworkImage(
                                currentItem.imageUrl.toString(),
                              ),
                              fit: BoxFit.fill)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText().createText(
                                  title: currentItem.title, size: 18),
                              CustomText().createText(
                                  title: 'quantity: ' +
                                      currentItem.quantity.toString(),
                                  size: 18),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText().createText(
                                  title: 'unitPrice: ${currentItem.unitPrice}',
                                  size: 18),
                              CustomText().createText(
                                  title: 'subtotal: ${currentItem.subtotal}',
                                  size: 18),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ));
          },
        )
      ]),
    );
  }
}
