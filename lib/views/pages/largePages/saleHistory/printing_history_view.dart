import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_system/services/controller/order_controller.dart';
import 'package:printing/printing.dart';

import '../../../../services/controller/auth_controller.dart';
import '../../../../services/controller/cart_controller.dart';
import '../../../../services/controller/user_controller.dart';



class PrintingHistoryView{
  OrderController controller=Get.put((OrderController()));
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    var coData=Get.find<AuthController>().coDetails;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Text('INVOICE NO #${Get.find<CartController>().printedFactorId.value}',style: pw.TextStyle(fontSize: 22,fontWeight: pw.FontWeight.bold))),
              pw.Center(child: pw.Text(coData['name_en'])),
              pw.Center(child: pw.Text(coData['address_en'])),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Center(child: pw.Text(coData['phone'])),
                    pw.SizedBox(width: 50),
                    pw.Center(child: pw.Text(coData['mobile'])),
                  ]),
              pw.Center(child: pw.Text(Get.find<AuthController>().webSite)),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Center(child: pw.Text('Cashier: ${Get.find<UserController>().name}')),
                    pw.Column(children: [
                      pw.Center(child: pw.Text(DateTime.now().year.toString()+'-'+DateTime.now().month.toString()+'-'+DateTime.now().day.toString()),),
                      pw.Center(child: pw.Text(DateTime.now().hour.toString()+':'+DateTime.now().minute.toString()),)
                    ])
                  ]
              ),
              pw.Divider(),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                pw.Expanded(flex: 1,child: pw.Text('#')),
                pw.Expanded(flex: 3,child: pw.Text('Item')),
                pw.Expanded(flex: 1,child: pw.Text('QTY')),
                pw.Expanded(flex: 1,child: pw.Text('Price')),
                pw.Expanded(flex: 1,child: pw.Text('Total')),
              ]),
              pw.Divider(),
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
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Expanded(flex: 1,child: pw.Text(currentItem.productId.toString())),
                          pw.Expanded(flex: 3,child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children:[
                                pw.Text(currentItem.title.toString(),overflow: pw.TextOverflow.clip,),
                                pw.Text(currentItem.titleAr.toString(),),
                              ])),
                          pw.Expanded(flex: 1,child: pw.Text(currentItem.quantity.toString())),
                          pw.Expanded(flex: 1,child: pw.Text(currentItem.unitPrice.toString())),
                         pw.Expanded(flex: 1,child: pw.Text(currentItem.subtotal.toString())),
                        ]);
                  }, separatorBuilder: (pw.Context context, int index) { return pw.SizedBox(height: 9); },
                  )
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total: '),
                    pw.Text(Get.find<CartController>().totalAmountForPrint.toString()),
                  ]),
              pw.Divider(thickness: 2),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Qty: ${controller.orderItemsList.length}'),
                    pw.Text('Total:  ${Get.find<CartController>().totalAmountForPrint.toString()}',),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                     pw.SizedBox(),
                    pw.Text('Paid: ${Get.find<CartController>().totalPaidForPrint.toString()}',),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text('Balance: ${Get.find<CartController>().totalPaidForPrint-
                        Get.find<CartController>().totalAmountForPrint}',),
                  ]),
              pw.SizedBox(height: 25),
              pw.Center(child: pw.Text(coData['pos_note_en']))
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}