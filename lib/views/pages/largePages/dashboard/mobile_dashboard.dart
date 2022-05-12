import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/shimmer/product_shimmer.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_drawer.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_main.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/sidebar.dart';
import 'package:xid/xid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MobileDashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MobileDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: Drawer(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              height: Get.height.toDouble(),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: DashboardDrawer().createDrawer()),
        ),
        drawer: Drawer(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              height: Get.height.toDouble(),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: DashboardSidebar().createSidebar()),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder(builder: (CartController controller) {
                  return PopupMenuButton(
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            PopupMenuItem(
                              child: ListTile(
                                  onTap: () {
                                    Get.find<CartController>().newSale();
                                  },
                                  leading: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    'new_sale'.tr,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                  onTap: () {},
                                  leading: const Icon(
                                    Icons.redo_sharp,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    'refund'.tr,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                  onTap: () async {
                                    await Printing.layoutPdf(onLayout: (_) => _generatePdf());
                                  },
                                  leading: const Icon(
                                    Icons.print,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    'Print'.tr,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                          ]);
                }),
                CustomText().createText(
                    title: 'appName'.tr,
                    size: 18.0,
                    fontWeight: FontWeight.bold),
                InkWell(
                    onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                    child: const Icon(
                      Icons.menu,
                      size: 30.0,
                    ))
              ],
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                padding: const EdgeInsets.all(8.0),
                height: Get.height.toDouble(),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Get.find<ProductController>().productList.isEmpty
                    ? ProductShimmer().createProductShimmer(gridCnt: 2)
                    : DashboardMain()
                        .createMain(gridCnt: 2, key: scaffoldKey))),
      ),
    );
  }
  Future<Uint8List> _generatePdf() async {
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
                      itemCount: Get.find<CartController>().addToCartListForPrint.length, itemBuilder: (pw.Context context, int index) {
                    var currentItem =
                    Get.find<CartController>().addToCartListForPrint[index];
                    double itemQty =
                    double.parse(currentItem.quantity.toString());
                    double itemPrc =
                    double.parse(currentItem.price.toString());
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
                                pw.Text('${currentItem.price}'),
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
                    pw.Text(Get.find<CartController>().totalAmountForPrint.toString(),),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Discount: '),
                    pw.Text('- ${Get.find<CartController>().discountAmountForPrint.toString()}',),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Delivery: '),
                    pw.Text('+ ${Get.find<CartController>().deliveryAmountForPrint.toString()}',),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total: '),
                    pw.Text((Get.find<CartController>().totalAmountForPrint +
                        Get.find<CartController>().deliveryAmountForPrint -
                        Get.find<CartController>().discountAmountForPrint)
                        .toString(),),
                  ]),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
