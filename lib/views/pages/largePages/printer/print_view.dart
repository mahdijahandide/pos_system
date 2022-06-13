import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../services/controller/cart_controller.dart';
import '../../../components/texts/customText.dart';

class PrintView extends StatelessWidget {
  const PrintView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText().createText(
            title: 'Print Preview', size: 18, fontWeight: FontWeight.bold),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Text('Pos system factor')),
              pw.SizedBox(height: 10),
              pw.SizedBox(
                  width: double.infinity,
                  child: pw.ListView.separated(
                      itemCount:
                          Get.find<CartController>().addToCartList.value.length,
                      itemBuilder: (pw.Context context, int index) {
                        var currentItem = Get.find<CartController>()
                            .addToCartList
                            .value[index];
                        double itemQty =
                            double.parse(currentItem.quantity.toString());
                        double itemPrc =
                            double.parse(currentItem.price.toString());
                        double itemPrice = itemQty * itemPrc;
                        return pw.Row(
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.FittedBox(
                                  child: pw.Text(
                                    currentItem.title.toString(),
                                  ),
                                ),
                                pw.SizedBox(
                                  height: 8,
                                ),
                                pw.Row(
                                  children: [
                                    pw.SizedBox(
                                      width: 5,
                                    ),
                                    pw.Text(
                                      '#${index + 1}',
                                    ),
                                    pw.SizedBox(
                                      width: 8,
                                    ),
                                    pw.Text(double.parse(
                                            currentItem.price.toString())
                                        .toStringAsFixed(3)),
                                    pw.SizedBox(
                                      width: 5,
                                    ),
                                    pw.Text(itemPrice.toStringAsFixed(3)),
                                  ],
                                )
                              ],
                            ),
                            pw.SizedBox(
                              width: 4,
                            ),
                            pw.FittedBox(
                                fit: pw.BoxFit.scaleDown,
                                child: pw.Text(currentItem.quantity.toString(),
                                    style: const pw.TextStyle(fontSize: 14)))
                          ],
                        );
                      },
                      separatorBuilder: (pw.Context context, int index) {
                        return pw.SizedBox(
                            width: Get.width,
                            child: pw.Divider(
                              thickness: 1,
                            ));
                      })),
              pw.SizedBox(height: 12),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total: '),
                    pw.Text(
                      Get.find<CartController>().totalAmount.toStringAsFixed(3),
                    ),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Discount: '),
                    pw.Text(
                      '- ${Get.find<CartController>().discountAmount.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Delivery: '),
                    pw.Text(
                      '+ ${Get.find<CartController>().deliveryAmount.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total: '),
                    pw.Text(
                      (Get.find<CartController>().totalAmount +
                              Get.find<CartController>().deliveryAmount -
                              Get.find<CartController>().discountAmount)
                          .toStringAsFixed(3),
                    ),
                  ]),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
