import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/controller/cash_controller.dart';

import 'package:pos_system/services/controller/user_controller.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:printing/printing.dart';

import '../../views/dialogs/loading_dialogs.dart';

import '../model/cash_history_model.dart';

import '../remotes/local_storage.dart';
import '../remotes/remote_status_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ShiftController extends GetxController {
  TextEditingController valController = TextEditingController();
  Rx<TextEditingController> cashCount = Rx(TextEditingController());
  Rx<TextEditingController> cardCount = Rx(TextEditingController());

  RxDouble startCash = 0.0.obs;
  RxDouble sellCash = 0.0.obs;
  RxDouble sellCard = 0.0.obs;
  RxDouble cashIn = 0.0.obs;
  RxDouble totalSell = 0.0.obs;
  RxDouble totalFunds = 0.0.obs;
  RxDouble totalRefund = 0.0.obs;
  RxDouble refundCash = 0.0.obs;
  RxDouble refundCard = 0.0.obs;
  RxDouble totalCashFunds = 0.0.obs;

  RxBool selectStartShift = true.obs;
  RxBool showLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    shiftDetailsRequest();
  }

  Future<void> shiftDetailsRequest() async {
    showLoading.value = true;
    var url = SHIFT_DETAILS;
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}'
      },
    );
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      selectStartShift.value = false;
      startCash.value =
          double.parse(jsonObject['data']['startCash'].toString());
      sellCash.value = double.parse(jsonObject['data']['sellCash'].toString());
      sellCard.value = double.parse(jsonObject['data']['sellCard'].toString());
      cashIn.value = double.parse(jsonObject['data']['cashIn'].toString());
      totalSell.value =
          double.parse(jsonObject['data']['totalSell'].toString());
      totalFunds.value =
          double.parse(jsonObject['data']['totalFunds'].toString());
      totalRefund.value =
          double.parse(jsonObject['data']['totalRefund'].toString());
      refundCash.value =
          double.parse(jsonObject['data']['refundCash'].toString());
      refundCard.value =
          double.parse(jsonObject['data']['refundCard'].toString());
      totalCashFunds.value =
          double.parse(jsonObject['data']['totalCashFunds'].toString());
      cashCount.value.text = '0';
      cardCount.value.text = '0';
      Get.find<CashController>().cashHistoryList.value.clear();
      jsonObject['data']['history'].forEach((element) {
        Get.find<CashController>()
            .cashHistoryList
            .value
            .add(CashHistoryModel(data: element));
      });
      showLoading.value = false;
    } else if (response.statusCode == 400) {
      showLoading.value = false;
      selectStartShift.value = true;
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> startCashRequest({required starterValue}) async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = SHIFT_START;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{'startCash': '$starterValue'}));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      LocalStorageHelper.removeValue('cartData');
      Get.back();
      shiftDetailsRequest();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> endCashRequest() async {
    LoadingDialog.showCustomDialog(msg: 'loading'.tr);
    var url = SHIFT_END;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{
          'countCash': cashCount.value.text.toString(),
          'countCard': cardCount.value.text.toString(),
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);

      selectStartShift.value = true;
      Get.back();
      LocalStorageHelper.removeValue('cartData');
      await Printing.layoutPdf(
          onLayout: (_) => generatePdf(data: jsonObject['data']));
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<Uint8List> generatePdf({required data}) async {
    var coData = Get.find<AuthController>().coDetails;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Text('Shift Report')),
              pw.Center(child: pw.Text(coData['name_en'])),
              pw.Center(child: pw.Text(coData['address_en'])),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Center(child: pw.Text('Phone: ' + coData['phone'])),
                pw.SizedBox(width: 10),
                pw.Center(child: pw.Text('Mobile: ' + coData['mobile'])),
              ]),
              pw.Center(child: pw.Text(Get.find<AuthController>().webSite)),
              pw.SizedBox(height: 10),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Center(
                        child: pw.Text(
                            'Cashier: ${Get.find<UserController>().name}')),
                    pw.Column(children: [
                      pw.Center(
                        child: pw.Text('Start at: ' + data['start'].toString()),
                      ),
                      pw.Center(
                        child: pw.Text('End at: ' + data['ended'].toString()),
                      )
                    ])
                  ]),
              pw.Divider(),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Start Cash: '),
                    pw.Text(startCash.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sell Cash: '),
                    pw.Text(sellCash.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sell Card: '),
                    pw.Text(sellCard.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Cash in: '),
                    pw.Text(cashIn.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Sell: '),
                    pw.Text(totalSell.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Funds: '),
                    pw.Text(totalFunds.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Refunds: '),
                    pw.Text(totalRefund.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Refund Cash: '),
                    pw.Text(refundCash.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Refund Card: '),
                    pw.Text(refundCard.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Cash funds: '),
                    pw.Text(totalCashFunds.value.toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Cash Count: '),
                    pw.Text(
                        double.parse(cashCount.value.text).toStringAsFixed(3)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Card Count: '),
                    pw.Text(
                        double.parse(cardCount.value.text).toStringAsFixed(3)),
                  ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                pw.Expanded(flex: 3, child: pw.Text('Title')),
                pw.Expanded(flex: 1, child: pw.Text('Amount')),
              ]),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Cash History'),
              pw.SizedBox(height: 10),
              pw.SizedBox(
                  width: double.infinity,
                  child: pw.ListView.separated(
                    itemCount:
                        Get.find<CashController>().cashHistoryList.value.length,
                    itemBuilder: (pw.Context context, int index) {
                      var currentItem = Get.find<CashController>()
                          .cashHistoryList
                          .value[index];
                      return pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Expanded(
                                flex: 3,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(currentItem.type.toString(),
                                          overflow: pw.TextOverflow.clip,
                                          maxLines: 1),
                                      pw.Text(
                                        currentItem.description.toString(),
                                        maxLines: 2,
                                        overflow: pw.TextOverflow.clip,
                                      ),
                                    ])),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    currentItem.amount!.toStringAsFixed(3))),
                          ]);
                    },
                    separatorBuilder: (pw.Context context, int index) {
                      return pw.SizedBox(height: 9);
                    },
                  )),
              pw.SizedBox(height: 12),
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
