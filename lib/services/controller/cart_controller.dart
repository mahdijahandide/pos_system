import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/user_controller.dart';
import 'package:pos_system/services/model/cart_product_model.dart';
import 'package:pos_system/services/model/province_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/services/remotes/local_storage.dart';
import 'package:pos_system/services/remotes/remote_status_handler.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/dialogs/area_province_dialog.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:pos_system/views/pages/largePages/modals/success_modal.dart';
import 'package:printing/printing.dart';
import 'package:xid/xid.dart';
import '../../views/components/buttons/custom_text_button.dart';
import '../../views/components/texts/customText.dart';
import '../model/temp_orders_model.dart';
import 'auth_controller.dart';
import 'customer_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'order_controller.dart';

class CartController extends GetxController {
  String uniqueId = 'pos${Xid()}';
  late RxString cartPrice;
  double totalAmount = 0.0;
  double totalAmountForPrint = 0.0;
  double subTotalAmountForPrint = 0.0;
  double totalPaidForPrint = 0.0;
  double discountAmount = 0.0;
  double discountAmountForPrint = 0.0;
  double deliveryAmount = 0.0;
  double deliveryAmountForPrint = 0.0;

  RxBool isRefund = false.obs;

  RxString printedFactorId = ''.obs;

  RxString selectedCountryName = ''.obs;
  RxString selectedProvinceName = ''.obs;
  RxString selectedAreaName = ''.obs;
  RxString selectedPaymentType = 'PCARD'.obs;
  RxString balanceStatus = ''.obs;
  String selectedCountryId = '';
  String selectedProvinceId = '';
  String selectedAreaId = '';
  String refundCartTotalPrice = '';

  Rx<List<CartProductModel>> addToCartList = Rx<List<CartProductModel>>([]);
  Rx<List<CartProductModel>> refundFactorItemList =
      Rx<List<CartProductModel>>([]);
  List<CartProductModel> addToCartListForPrint = [];
  List<TempOrderModel> openCartsUDID = [];
  List<ProvinceModel> countryList = [];
  var addToCartJson = {};

  TextEditingController calController = TextEditingController();
  TextEditingController refundFactorNumController = TextEditingController();

  Future<void> addToCart(
      {required productId,
      required price,
      required quantity,
      required optionSc,
      required tempUniqueId,
      dynamic openModal,
      dynamic openDialog,
      dynamic colorAttribute,
      dynamic sizeAttribute,
      dynamic otherAttribute,
      dynamic otherId,
      dynamic otherValue,
      dynamic title,
      dynamic titleAr}) async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = ADD_TO_CART;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, dynamic>{
          'product_id': productId,
          'price': price,
          'quantity': quantity,
          'temp_uniqueid': tempUniqueId,
          'option_scection_id': optionSc.toString(),
          if (isRefund.isTrue) 'refund': '1',
          if (colorAttribute != null)
            'color_attribute': colorAttribute.toString(),
          if (sizeAttribute != null) 'size_attribute': sizeAttribute.toString(),
          if (otherAttribute != null) 'option': {"$otherId": otherValue}
        }));
    if (response.statusCode == 200) {
      AudioPlayer audioPlayer = AudioPlayer();
      const alarmAudioPath = "assets/sounds/beep.mp3";
      audioPlayer.play(alarmAudioPath);

      var jsonObject = convert.jsonDecode(response.body);
      addToCartList.value.add(CartProductModel(
          mId: jsonObject['data']['cart_item_id'],
          mPrice: price,
          mQuantity: quantity,
          mTitle: title,
          mTempUniqueId: tempUniqueId,
          pId: int.parse(productId),
          mTitleAr: titleAr));
      totalAmount = double.parse(jsonObject['data']['total_amount'].toString());

      saveCartForSecondMonitor();

      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: '',
          msg: 'item added to cart successfully',
          bgColor: Colors.green,
          msgColor: Colors.black,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ));
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> editCartProductQuantity(
      {required tempId,
      required quantity,
      required tempUniqueId,
      required index}) async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = EDIT_CART_QTY;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{
          'tempid': tempId,
          'quantity': quantity,
          'temp_uniqueid': tempUniqueId,
          if (isRefund.isTrue) 'refund': '1',
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());

      if (addToCartList.value[index].quantity == '0') {
        addToCartList.value.removeAt(index);
        saveCartForSecondMonitor();
      } else {
        addToCartList.value[index].quantity = quantity.toString();
        saveCartForSecondMonitor();
      }
      totalAmount = double.parse(jsonObject['data']['total_amount'].toString());

      Get.back(closeOverlays: true);
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> removeCartProductItem({
    required id,
    required index,
    required tempUniqueId,
  }) async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = REMOVE_FROM_CART;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{
          'id': id.toString(),
          'temp_uniqueid': tempUniqueId,
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());
      double itemQty =
          double.parse(addToCartList.value[index].quantity.toString());
      double itemPrc =
          double.parse(addToCartList.value[index].price.toString());
      double itemPrice = itemQty * itemPrc;
      totalAmount = totalAmount - itemPrice;
      addToCartList.value.removeAt(int.parse(index.toString()));
      saveCartForSecondMonitor();
      update();
      Get.find<CartController>().update();

      Get.back(closeOverlays: true);
      if (addToCartList.value.isEmpty) {
        discountAmount = 0.0;
        deliveryAmount = 0.0;
      }
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> removeAllFromCart({
    required tempUniqueId,
  }) async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = REMOVE_ALL_FROM_CART;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, String>{
          'temp_uniqueid': tempUniqueId,
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());

      addToCartList.value.clear();
      totalAmount = 0.0;
      saveCartForSecondMonitor();
      update();
      Get.find<CartController>().update();

      Get.back(closeOverlays: true);
      discountAmount = 0.0;
      deliveryAmount = 0.0;
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> getAreas({dynamic doInBackground, dynamic hasLoading}) async {
    countryList.clear();
    if (hasLoading != false) {
      LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    }
    var url = GET_AREAS;
    final http.Response response =
        await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthController>().token}'
    });
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());
      jsonObject['data'].forEach((element) {
        countryList.add(ProvinceModel(data: element));
      });
      Get.back(closeOverlays: true);

      if (doInBackground != true) {
        AreaProvinceDialog.showCustomDialog(title: 'Province & Areas');
      }
      Get.find<CartController>().update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> checkoutCart() async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    print(jsonEncode(<String, dynamic>{
      'temp_uniqueid': uniqueId,
      if (Get.find<CustomerController>()
          .customerNumberController
          .text
          .isNotEmpty)
        'customer_id': Get.find<CustomerController>()
            .customerList
            .where((element) =>
                element.mobile.toString() ==
                Get.find<CustomerController>()
                    .customerNumberController
                    .text
                    .toString())
            .first
            .id
            .toString(),
      'name': Get.find<CustomerController>().customerNameController.text,
      'mobile': Get.find<CustomerController>().customerNumberController.text,
      'email': Get.find<CustomerController>().customerEmailController.text,
      'delivery_status': deliveryAmount > 0 ? '1' : '0',
      if (deliveryAmount > 0) 'area': selectedAreaId.toString(),
      'user_discount': discountAmount.toString(),
      'transactions': [
        {
          'type': selectedPaymentType.value,
          'amount': (totalAmount - discountAmount + deliveryAmount)
              .toString(), //calController.text,
          'status': 'CAPTURED',
        }
      ]
    }));
    var url = CHECKOUT_CART;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, dynamic>{
          'temp_uniqueid': uniqueId,
          if (Get.find<CustomerController>()
              .customerNumberController
              .text
              .isNotEmpty)
            'customer_id': Get.find<CustomerController>()
                .customerList
                .where((element) =>
                    element.mobile.toString() ==
                    Get.find<CustomerController>()
                        .customerNumberController
                        .text
                        .toString())
                .first
                .id
                .toString(),
          'name': Get.find<CustomerController>().customerNameController.text,
          'mobile':
              Get.find<CustomerController>().customerNumberController.text,
          'email': Get.find<CustomerController>().customerEmailController.text,
          'delivery_status': deliveryAmount > 0 ? '1' : '0',
          if (deliveryAmount > 0) 'area': selectedAreaId.toString(),
          'user_discount': discountAmount.toString(),
          'transactions': [
            {
              'type': selectedPaymentType.value,
              'amount': (totalAmount - discountAmount + deliveryAmount)
                  .toString(), //calController.text,
              'status': 'CAPTURED',
            }
          ]
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());
      addToCartListForPrint.clear();
      for (int i = 0; i < addToCartList.value.length; i++) {
        addToCartListForPrint.add(CartProductModel(
            mId: addToCartList.value[i].id,
            pId: addToCartList.value[i].productId,
            mPrice: addToCartList.value[i].price,
            mQuantity: addToCartList.value[i].quantity,
            mTitle: addToCartList.value[i].title,
            mTempUniqueId: addToCartList.value[i].tempUniqueId,
            mTitleAr: addToCartList.value[i].titleAr));
      }

      printedFactorId.value = jsonObject['data']['trackid'];
      totalPaidForPrint = double.parse(calController.text.toString());
      totalAmountForPrint = totalAmount;
      deliveryAmountForPrint = deliveryAmount;
      discountAmountForPrint = discountAmount;

      addToCartList.value.clear();
      newSale();

      // Fluttertoast.showToast(
      //     msg: isRefund.isFalse
      //         ? "cart paid successfully"
      //         : "cart Refund successfully", // message
      //     toastLength: Toast.LENGTH_SHORT, // length
      //     gravity: ToastGravity.CENTER, // location
      //     timeInSecForIosWeb: 2,
      //     fontSize: 22,
      //     webPosition: 'center');
      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: '',
          msg: isRefund.isFalse
              ? 'cart paid successfully'
              : 'cart refund successfully',
          bgColor: Colors.green,
          msgColor: Colors.black,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ));
      Get.bottomSheet(
        const SuccessModal(),
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      );
      Get.find<CustomerController>().customerNameController.text = '';
      Get.find<CustomerController>().customerEmailController.text = '';
      Get.find<CustomerController>().customerNumberController.text = '';
      discountAmount = 0;
      deliveryAmount = 0;
      Get.find<CustomerController>().selectedCustomer = null;
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> refundCartRequest() async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = getRefundCartRoute(refundFactorNumController.text.toString());
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, dynamic>{
          'transactions': [
            {
              'type': selectedPaymentType.value,
              'amount': calController.text,
            }
          ]
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());

      addToCartList.value.clear();
      totalAmount = 0.0;
      deliveryAmount = 0.0;
      discountAmount = 0.0;
      uniqueId = 'pos${Xid()}';
      isRefund.value = false;

      Get.find<OrderController>().orderList.value.clear();
      Get.find<OrderController>().orderFilteredList.value.clear();
      Get.find<OrderController>().orderItemsList.clear();
      Get.find<OrderController>().hasList.value = false;

      // Fluttertoast.showToast(
      //     msg: "cart Refund successfully", // message
      //     toastLength: Toast.LENGTH_SHORT, // length
      //     gravity: ToastGravity.CENTER, // location
      //     webPosition: 'center',
      //     timeInSecForIosWeb: 2 // duration
      //     );

      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: '',
          msg: 'cart refund successfully',
          bgColor: Colors.green,
          msgColor: Colors.black,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ));
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> refundCartItemRequest() async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = getRefundCartItemRoute(refundFactorNumController.text.toString());
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, dynamic>{
          'temp_uniqueid': uniqueId,
          'transactions': [
            {
              'type': selectedPaymentType.value,
              'amount': calController.text,
            }
          ]
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      Get.log(jsonObject.toString());

      addToCartList.value.clear();
      totalAmount = 0.0;
      deliveryAmount = 0.0;
      discountAmount = 0.0;
      uniqueId = 'pos${Xid()}';
      isRefund.value = false;

      Get.find<OrderController>().orderList.value.clear();
      Get.find<OrderController>().orderFilteredList.value.clear();
      Get.find<OrderController>().orderItemsList.clear();
      Get.find<OrderController>().hasList.value = false;
      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: '',
          msg: 'cart item refund successfully',
          bgColor: Colors.green,
          msgColor: Colors.black,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ));
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> getTempOrders(
      {required cartId,
      dynamic index,
      dynamic areaId,
      dynamic userDiscount}) async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = GET_TEMP_ORDERS;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, dynamic>{
          'temp_uniqueid': cartId.toString(),
          'area_id': areaId ?? '',
          'user_discount': userDiscount ?? '',
        }));
    if (response.statusCode == 200) {
      var jsonObject = convert.jsonDecode(response.body);
      var temps = jsonObject['data']['temoOrders'];
      uniqueId = cartId.toString();

      if (index != null) {
        discountAmount = openCartsUDID[index].discount!.toDouble();
        deliveryAmount = openCartsUDID[index].delivery!.toDouble();
      }

      addToCartList.value.clear();
      temps.forEach((element) {
        addToCartList.value.add(CartProductModel(
            mId: element['id'],
            mPrice: element['unitprice'].toString(),
            mQuantity: element['quantity'].toString(),
            mTitle: element['title'],
            mTempUniqueId: uniqueId,
            pId: element['product_id'],
            mTitleAr: element['title']));
      });
      if (index != null) openCartsUDID.removeAt(index);
      Get.back(closeOverlays: true);

      totalAmount = double.parse(jsonObject['data']['total'].toString());

      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  void newSale() {
    if (addToCartList.value.isNotEmpty) {
      openCartsUDID.add(TempOrderModel(mId: uniqueId));
      totalAmount = 0.0;
      deliveryAmount = 0.0;
      discountAmount = 0.0;
      uniqueId = 'pos${Xid()}';
      addToCartList.value.clear();
      update();
    } else {
      totalAmount = 0.0;
      deliveryAmount = 0.0;
      discountAmount = 0.0;
      uniqueId = 'pos${Xid()}';
      update();
    }
  }

  void saveCartForSecondMonitor() {
    addToCartJson = {
      'subTotal': totalAmount.toString(),
      'discount': discountAmount.toString(),
      'delivery': deliveryAmount.toString(),
      'data': [
        for (int i = 0; i < addToCartList.value.length; i++)
          {
            'id': addToCartList.value[i].id,
            'productId': addToCartList.value[i].productId,
            'price': addToCartList.value[i].price,
            'quantity': addToCartList.value[i].quantity,
            'title': addToCartList.value[i].title,
            'tempUniqueId': addToCartList.value[i].tempUniqueId,
          },
      ]
    };
    LocalStorageHelper.saveValue(
        'cartData', jsonEncode(addToCartJson).toString());
  }

  Future<Uint8List> generatePdf() async {
    // final ttf = await fontFromAssetBundle('assets/fonts/pelak.ttf');
    var coData = Get.find<AuthController>().coDetails;
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: false,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(
                  child: pw.Text('INVOICE NO #${printedFactorId.value}',
                      style: pw.TextStyle(
                          fontSize: 22, fontWeight: pw.FontWeight.bold))),
              pw.Center(
                  child: pw.Text(coData['name_en'],
                      style: const pw.TextStyle(fontSize: 20))),
              pw.Center(
                  child: pw.Text(coData['address_en'],
                      style: const pw.TextStyle(fontSize: 20))),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Center(
                    child: pw.Text(coData['phone'],
                        style: const pw.TextStyle(fontSize: 20))),
                pw.SizedBox(width: 50),
                pw.Center(
                    child: pw.Text(coData['mobile'],
                        style: const pw.TextStyle(fontSize: 20))),
              ]),
              pw.Center(
                  child: pw.Text(Get.find<AuthController>().webSite,
                      style: const pw.TextStyle(fontSize: 20))),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Center(
                        child: pw.Text(
                            'Cashier: ${Get.find<UserController>().name}',
                            style: const pw.TextStyle(fontSize: 20))),
                    pw.Column(children: [
                      pw.Center(
                        child: pw.Text(
                            DateTime.now().year.toString() +
                                '-' +
                                DateTime.now().month.toString() +
                                '-' +
                                DateTime.now().day.toString(),
                            style: const pw.TextStyle(fontSize: 20)),
                      ),
                      pw.Center(
                        child: pw.Text(
                            DateTime.now().hour.toString() +
                                ':' +
                                DateTime.now().minute.toString(),
                            style: const pw.TextStyle(fontSize: 20)),
                      )
                    ])
                  ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                pw.Expanded(
                    flex: 1,
                    child:
                        pw.Text('#', style: const pw.TextStyle(fontSize: 18))),
                pw.Expanded(
                    flex: 3,
                    child: pw.Text('Item',
                        style: const pw.TextStyle(fontSize: 18))),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('QTY',
                        style: const pw.TextStyle(fontSize: 18))),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Price',
                        style: const pw.TextStyle(fontSize: 18))),
                pw.Expanded(
                    flex: 1,
                    child: pw.Text('Total',
                        style: const pw.TextStyle(fontSize: 18))),
              ]),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.SizedBox(
                  width: double.infinity,
                  child: pw.ListView.separated(
                    itemCount: addToCartListForPrint.length,
                    itemBuilder: (pw.Context context, int index) {
                      var currentItem = addToCartListForPrint[index];
                      double itemQty =
                          double.parse(currentItem.quantity.toString());
                      double itemPrc =
                          double.parse(currentItem.price.toString());
                      double itemPrice = itemQty * itemPrc;
                      return pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(currentItem.productId.toString(),
                                    style: const pw.TextStyle(fontSize: 20))),
                            pw.Expanded(
                                flex: 3,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        currentItem.title.toString(),
                                        style: const pw.TextStyle(fontSize: 20),
                                        overflow: pw.TextOverflow.clip,
                                      ),
                                      pw.Text(currentItem.titleAr.toString(),
                                          style:
                                              const pw.TextStyle(fontSize: 20)),
                                    ])),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(currentItem.quantity.toString(),
                                    style: const pw.TextStyle(fontSize: 20))),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                  double.parse(
                                    currentItem.price.toString(),
                                  ).toStringAsFixed(3),
                                  style: const pw.TextStyle(fontSize: 20)),
                            ),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(itemPrice.toStringAsFixed(3),
                                    style: const pw.TextStyle(fontSize: 20))),
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
                    pw.Text('Subtotal: ',
                        style: const pw.TextStyle(fontSize: 20)),
                    pw.Text(totalAmountForPrint.toStringAsFixed(3),
                        style: const pw.TextStyle(fontSize: 20)),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Qty: ${addToCartListForPrint.length}',
                        style: const pw.TextStyle(fontSize: 20)),
                    pw.Text(
                        'Delivery: ${deliveryAmountForPrint.toStringAsFixed(3)}',
                        style: const pw.TextStyle(fontSize: 20)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                        'Discount: ${discountAmountForPrint.toStringAsFixed(3)}',
                        style: const pw.TextStyle(fontSize: 20)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                        'Total:  ${(totalAmountForPrint - discountAmountForPrint + deliveryAmountForPrint).toStringAsFixed(3)}',
                        style: const pw.TextStyle(fontSize: 20)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text('Paid: ${totalPaidForPrint.toStringAsFixed(3)}',
                        style: const pw.TextStyle(fontSize: 20)),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                        'Balance: ${(totalPaidForPrint - (totalAmountForPrint - discountAmountForPrint + deliveryAmountForPrint)).toStringAsFixed(3)}',
                        style: const pw.TextStyle(fontSize: 20)),
                  ]),
              pw.SizedBox(height: 25),
              pw.Center(
                  child: pw.Text(coData['pos_note_en'],
                      style: const pw.TextStyle(fontSize: 20)))
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
