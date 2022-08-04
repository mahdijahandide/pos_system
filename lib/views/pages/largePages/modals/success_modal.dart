import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:printing/printing.dart';
import '../../../../helper/webview_widget_factory.dart';
import '../../../../services/remotes/api_routes.dart';
import '../../../components/buttons/custom_text_button.dart';
import '../../../components/texts/customText.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class SuccessModal extends GetView<CartController> {
  String md5Id;
  SuccessModal({Key? key, required this.md5Id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var md5FactorId = md5.convert(utf8.encode(md5Id)).toString();
    String url = MD5_PRINT_URL + md5FactorId;
    return Obx(
      () => Container(
        color: Colors.white,
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Container(
              width: Get.width,
              color: Colors.grey.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  CustomText().createText(
                      title: 'Success',
                      size: 18,
                      color: Colors.black,
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
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on),
                CustomText().createText(
                    title: controller.balanceStatus.value == ''
                        ? 'change: 0.000'
                        : controller.balanceStatus.value,
                    fontWeight: FontWeight.bold,
                    size: 22,
                    color: Colors.green),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            CustomText().createText(
                title: 'How would the customer like their receipt? ', size: 25),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 250,
                  height: 150,
                  child: CustomTextButton().createTextButton(
                      buttonText: 'Print',
                      buttonColor: Colors.white,
                      elevation: 6,
                      textColor: Colors.black,
                      icon: const Icon(Icons.print),
                      onPress: () async {
                        Get.back();
                        await Printing.layoutPdf(
                            onLayout: (_) => controller.generatePdf());
                      }),
                ),
                SizedBox(
                  width: 250,
                  height: 150,
                  child: CustomTextButton().createTextButton(
                      buttonText: 'Save',
                      buttonColor: Colors.white,
                      elevation: 6,
                      textColor: Colors.black,
                      icon: const Icon(Icons.save),
                      onPress: () async {
                        //Get.back();
                      }),
                ),
                SizedBox(
                  width: 250,
                  height: 150,
                  child: CustomTextButton().createTextButton(
                      buttonText: 'Print A4',
                      buttonColor: Colors.white,
                      elevation: 6,
                      textColor: Colors.black,
                      icon: const Icon(Icons.receipt),
                      onPress: () {
                        if (controller.a4selected.isTrue) {
                          controller.a4selected.value = false;

                          Get.back();
                          Get.bottomSheet(
                            SuccessModal(
                              md5Id: md5Id.toString(),
                            ),
                            isScrollControlled: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          );
                          controller.a4selected.value = true;
                          controller.update();
                        } else {
                          controller.a4selected.value = true;
                          controller.update();
                        }
                        LoadingDialog.showCustomDialog(msg: 'loading'.tr);
                        Timer(
                          const Duration(seconds: 3),
                          () {
                            Get.back();
                          },
                        );
                      }),
                ),
              ],
            ),
            controller.a4selected.isFalse
                ? const SizedBox()
                : SizedBox(
                    width: 0,
                    height: 0,
                    child: HtmlWidget(
                      '<iframe src="$url" ></iframe>',
                      factoryBuilder: () => MyWidgetFactory(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
