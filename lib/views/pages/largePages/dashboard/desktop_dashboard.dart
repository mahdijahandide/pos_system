import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/views/components/shimmer/product_shimmer.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_drawer.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_main.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/iconTextBox.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/sidebar.dart';
import 'package:vk/vk.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DesktopDashboard extends StatelessWidget {
  DesktopDashboard({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          key: scaffoldKey,
          endDrawer: Drawer(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                height: Get.height,
                decoration:
                BoxDecoration(border: Border.all(color: Colors.black)),
                child: DashboardDrawer().createDrawer()
            ),
          ),
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder(
                    builder: (CartController controller) {
                      return Row(
                        children: [
                              IconTextBox().createIconTextBox(height: 70.0,
                                  icon: Icons.add, title: 'new_sale'.tr, onTap: () {
                                   Get.find<CartController>().newSale();
                                  }),

                          const SizedBox(
                            width: 12,
                          ),
                          IconTextBox().createIconTextBox(height: 70.0,
                              icon: Icons.redo_sharp, title: 'refund'.tr, onTap: () {}),
                          const SizedBox(
                            width: 12,
                          ),
                          IconTextBox().createIconTextBox(height: 70.0,
                              icon: Icons.print,
                              title: 'Print'.tr,
                              onTap: () async {
                                await Printing.layoutPdf(onLayout: (_) => _generatePdf());
                              }
                              ),
                        ],
                      );
                    }
                  ),
                  InkWell(
                      onTap: () {
                        scaffoldKey.currentState!.openEndDrawer();
                        // Scaffold.of(context).openEndDrawer();
                      },
                      child: const Icon(
                        Icons.menu,
                        size: 45.0,
                      ))
                ],
              ),
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 6, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: Get.height,
                            decoration:
                            BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: DashboardSidebar().createSidebar()
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        flex: 8,
                        child:Container(
                            padding: const EdgeInsets.all(8.0),
                            height: Get.height,
                            decoration:
                            BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Get.find<ProductController>().productList.isEmpty
                                ?  ProductShimmer().createProductShimmer(gridCnt: 5,isLarge: true)
                                :  DashboardMain().createMain(gridCnt: 5, isLarge: true)
                        )

                       ),
                  ],
                ),
              ),

            ],
          ),
          bottomNavigationBar:
          Obx(()=>
          Get
              .find<DashboardController>()
              .isShowKeyboard
              .isTrue ? Container(
            color: const Color(0xffeeeeee),
            child: VirtualKeyboard(
                textColor: Colors.black,
                type: Get
                    .find<DashboardController>()
                    .isNumericMode
                    ? VirtualKeyboardType.Numeric
                    : VirtualKeyboardType.Alphanumeric,
                textController: Get
                    .find<DashboardController>()
                    .searchController),
          ) : const SizedBox(),
          )
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
