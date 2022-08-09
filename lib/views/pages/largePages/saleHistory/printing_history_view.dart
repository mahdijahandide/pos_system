import 'dart:typed_data';
import 'package:barcode/barcode.dart';

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_system/services/controller/order_controller.dart';

import 'package:printing/printing.dart';

import '../../../../services/controller/auth_controller.dart';
import '../../../../services/controller/cart_controller.dart';
import '../../../../services/controller/user_controller.dart';

class PrintingHistoryView {
  OrderController controller = Get.put((OrderController()));
  Future<Uint8List> generatePdf() async {
    final barcode = Barcode.code128();
    final svg = barcode.toSvg(
        Get.find<CartController>().printedFactorId.value.toString(),
        width: 100,
        drawText: false,
        height: 50);

    final gf = await PdfGoogleFonts.iBMPlexSansArabicLight();

    final pdf = pw.Document();

    var coData = Get.find<AuthController>().coDetails;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(
                  child: pw.Text(
                      'INVOICE NO #${Get.find<CartController>().printedFactorId.value}',
                      style: pw.TextStyle(
                          fontSize: 15, fontWeight: pw.FontWeight.bold))),
              pw.Center(child: pw.Text(coData['name_en'])),
              pw.Center(
                  child: pw.Text(coData['address_en'],
                      textAlign: pw.TextAlign.center)),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Center(child: pw.Text('Phone: ' + coData['phone'])),
                pw.SizedBox(width: 10),
                pw.Center(child: pw.Text('Mobile: ' + coData['mobile'])),
              ]),
              pw.Center(child: pw.Text(Get.find<AuthController>().webSite)),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Center(
                        child: pw.Text(
                            'Cashier: ${Get.find<UserController>().name}')),
                    pw.Column(children: [
                      pw.Center(
                        child: pw.Text(DateTime.now().year.toString() +
                            '-' +
                            DateTime.now().month.toString() +
                            '-' +
                            DateTime.now().day.toString()),
                      ),
                      pw.Center(
                        child: pw.Text(DateTime.now().hour.toString() +
                            ':' +
                            DateTime.now().minute.toString()),
                      )
                    ])
                  ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('#',
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ))),
                pw.SizedBox(
                  width: 2,
                ),
                pw.Expanded(
                    flex: 3,
                    child: pw.Text('Item',
                        style: const pw.TextStyle(fontSize: 10))),
                pw.SizedBox(
                  width: 2,
                ),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('QTY',
                        style: const pw.TextStyle(fontSize: 10))),
                pw.SizedBox(
                  width: 2,
                ),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Price',
                        style: const pw.TextStyle(fontSize: 10))),
                pw.SizedBox(
                  width: 2,
                ),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Total',
                        style: const pw.TextStyle(fontSize: 10))),
              ]),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.SizedBox(
                  width: double.infinity,
                  child: pw.ListView.separated(
                    itemCount: controller.orderItemsList.length,
                    itemBuilder: (pw.Context context, int index) {
                      var currentItem = controller.orderItemsList[index];

                      return pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(currentItem.itemCode.toString(),
                                    style: const pw.TextStyle(fontSize: 8))),
                            pw.SizedBox(
                              width: 2,
                            ),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(currentItem.title.toString(),
                                          maxLines: 1,
                                          textAlign: pw.TextAlign.left,
                                          textDirection: pw.TextDirection.ltr,
                                          overflow: pw.TextOverflow.clip,
                                          style:
                                              const pw.TextStyle(fontSize: 10)),
                                      pw.Text(
                                        '${currentItem.titleAr}',
                                        maxLines: 1,
                                        textAlign: pw.TextAlign.right,
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(
                                            font: gf, fontSize: 10),
                                      ),
                                    ])),
                            pw.SizedBox(
                              width: 2,
                            ),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(currentItem.quantity.toString(),
                                    style: const pw.TextStyle(fontSize: 10))),
                            pw.SizedBox(
                              width: 2,
                            ),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    currentItem.unitPrice!.toStringAsFixed(3),
                                    style: const pw.TextStyle(fontSize: 10))),
                            pw.SizedBox(
                              width: 2,
                            ),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    currentItem.subtotal!.toStringAsFixed(3),
                                    style: const pw.TextStyle(fontSize: 10))),
                          ]);
                    },
                    separatorBuilder: (pw.Context context, int index) {
                      return pw.SizedBox(height: 9);
                    },
                  )),
              pw.SizedBox(height: 12),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Subtotal: '),
                    pw.Text(Get.find<CartController>()
                        .subTotalAmountForPrint
                        .toString()),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Qty: ${controller.orderItemsList.length}'),
                    pw.Text(
                      'Delivery: ${Get.find<CartController>().deliveryAmountForPrint.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Discount: ${Get.find<CartController>().discountAmountForPrint.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Total:  ${Get.find<CartController>().totalAmountForPrint.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Paid: ${Get.find<CartController>().totalPaidForPrint.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Balance: ${(Get.find<CartController>().totalPaidForPrint - Get.find<CartController>().totalAmountForPrint).toStringAsFixed(3)}',
                    ),
                  ]),
              pw.SizedBox(height: 25),
              Get.find<CartController>().customerAddressForPrint != ''
                  ? pw.Center(
                      child: pw.Text(
                      Get.find<CartController>().customerAddressForPrint,
                    ))
                  : pw.SizedBox(),
              pw.SizedBox(height: 12),
              pw.SvgImage(svg: svg),
              pw.SizedBox(height: 25),
              pw.Center(
                  child: pw.Text(
                      coData['pos_note_en'] ?? 'Thanks For Your Purchase'))
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
