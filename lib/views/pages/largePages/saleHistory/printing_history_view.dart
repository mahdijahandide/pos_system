import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:printing/printing.dart';



class PrintingHistoryView{
  OrderController controller=Get.put((OrderController()));
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Text('Pos system factor')),
              pw.SizedBox(height: 10),
              pw.SizedBox(
                  width: double.infinity,
                  child: pw.ListView.separated(
                      itemCount: controller.orderItemsList.length, itemBuilder: (pw.Context context, int index) {
                    var currentItem =
                    controller.orderItemsList[index];
                    double itemQty =
                    double.parse(currentItem.quantity.toString());
                    double itemPrc =
                    double.parse(currentItem.unitPrice.toString());
                    double itemPrice = itemQty * itemPrc;
                    return pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment:
                          pw.CrossAxisAlignment.start,
                          children: [
                            pw.FittedBox(
                              child: pw.Text(currentItem.title.toString(),),
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              children: [

                                pw.SizedBox(
                                  width: 5,
                                ),
                                pw.Text('#${index + 1}',),
                                pw.SizedBox(
                                  width: 8,
                                ),
                                pw.Text('${currentItem.unitPrice}'),
                                pw.SizedBox(
                                  width: 5,
                                ),
                                pw.Text(itemPrice.toString()),
                              ],
                            )
                          ],
                        ),

                        pw.SizedBox(
                          width: 4,
                        ),
                        pw.FittedBox(
                            fit: pw.BoxFit.scaleDown,
                            child:pw.Text(currentItem.quantity.toString(),style: const pw.TextStyle(fontSize: 14))
                        )
                      ],
                    );
                  }, separatorBuilder: (pw.Context context, int index) {
                    return
                      pw.SizedBox(
                          width: Get.width,
                          child:pw.Divider(thickness: 1,)
                      );

                  }
                  )
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Subtotal: '),
                    pw.Text(controller.selectedItem.totalAmount.toString(),),
                  ]),
              pw.Divider(thickness: 2),
              // pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //     children: [
              //       pw.Text('Discount: '),
              //       pw.Text('- ${controller.selectedItem.d.toString()}',),
              //     ]),
              // pw.Divider(thickness: 2),
              // pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //     children: [
              //       pw.Text('Delivery: '),
              //       pw.Text('+ ${Get.find<CartController>().deliveryAmountForPrint.toString()}',),
              //     ]),
              // pw.Divider(thickness: 2),
              // pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //     children: [
              //       pw.Text('Total: '),
              //       pw.Text((Get.find<CartController>().totalAmountForPrint +
              //           Get.find<CartController>().deliveryAmountForPrint -
              //           Get.find<CartController>().discountAmountForPrint)
              //           .toString(),),
              //     ]),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}