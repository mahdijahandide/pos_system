import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/controller/address_controller.dart';

import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/controller/user_controller.dart';
import 'package:pos_system/services/model/cart_product_model.dart';
import 'package:pos_system/services/model/customer_address_model.dart';
import 'package:pos_system/services/model/province_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/services/remotes/local_storage.dart';
import 'package:pos_system/services/remotes/remote_status_handler.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/dialogs/area_province_dialog.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:pos_system/views/dialogs/refund_factor_num_dialog.dart';
import 'package:pos_system/views/pages/largePages/modals/success_modal.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xid/xid.dart';
import '../../views/dialogs/customer_address_dialog.dart';
import '../model/temp_orders_model.dart';
import 'auth_controller.dart';
import 'customer_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:crypto/crypto.dart';

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
  RxBool hasModalVk = false.obs;

  RxBool a4selected = false.obs;

  RxString printedFactorId = ''.obs;

  String customerAddressForPrint = '';
  RxString selectedCountryName = ''.obs;
  RxString selectedProvinceName = ''.obs;
  RxString selectedAreaName = ''.obs;
  RxString selectedNewCountryName = ''.obs;
  RxString selectedNewProvinceName = ''.obs;
  RxString selectedNewAreaName = ''.obs;
  RxString selectedPaymentType = 'PCARD'.obs;
  RxString balanceStatus = ''.obs;
  String selectedCountryId = '';
  String selectedProvinceId = '';
  String selectedAreaId = '';
  String selectedNewCountryId = '';
  String selectedNewProvinceId = '';
  String selectedNewAreaId = '';
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
  TextEditingController passwordTxtController = TextEditingController();

  Future<void> addToCart(
      {required productId,
      required price,
      required quantity,
      required iCode,
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

    int qty = int.parse(quantity.toString());
    switch (optionSc.toString()) {
      case '1':
        bool contain = Get.find<CartController>()
                .addToCartList
                .value
                .where((element) =>
                    element.sizeId.toString() == sizeAttribute.toString() &&
                    element.itemCode.toString() == iCode.toString())
                .isEmpty
            ? false
            : true;
        if (contain) {
          qty = int.parse(Get.find<CartController>()
                  .addToCartList
                  .value
                  .where((element) =>
                      element.sizeId.toString() == sizeAttribute.toString() &&
                      element.itemCode.toString() == iCode.toString())
                  .first
                  .quantity
                  .toString()) +
              1;
        } else {
          qty = 1;
        }
        break;
      case '2':
        bool contain = Get.find<CartController>()
                .addToCartList
                .value
                .where((element) =>
                    element.colorId.toString() == colorAttribute.toString() &&
                    element.itemCode.toString() == iCode.toString())
                .isEmpty
            ? false
            : true;
        if (contain) {
          qty = int.parse(Get.find<CartController>()
                  .addToCartList
                  .value
                  .where((element) =>
                      element.colorId.toString() == colorAttribute.toString() &&
                      element.itemCode.toString() == iCode.toString())
                  .first
                  .quantity
                  .toString()) +
              1;
        } else {
          qty = 1;
        }
        break;
      case '3':
        bool contain = Get.find<CartController>()
                .addToCartList
                .value
                .where((element) =>
                    element.sizeId.toString() == sizeAttribute.toString() &&
                    element.colorId.toString() == colorAttribute.toString() &&
                    element.itemCode.toString() == iCode.toString())
                .isEmpty
            ? false
            : true;
        if (contain) {
          qty = int.parse(Get.find<CartController>()
                  .addToCartList
                  .value
                  .where((element) =>
                      element.sizeId.toString() == sizeAttribute.toString() &&
                      element.colorId.toString() == colorAttribute.toString() &&
                      element.itemCode.toString() == iCode.toString())
                  .first
                  .quantity
                  .toString()) +
              1;
        } else {
          qty = 1;
        }
        break;
      default:
        qty = 1;
    }

    var url = ADD_TO_CART;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, dynamic>{
          'product_id': productId,
          'price': price,
          'quantity': isRefund.isFalse ? qty.toString() : quantity,
          'temp_uniqueid': tempUniqueId,
          'option_scection_id': optionSc.toString(),
          if (isRefund.isTrue) 'refund': '1',
          if (colorAttribute != null)
            'color_attribute': colorAttribute.toString(),
          if (sizeAttribute != null) 'size_attribute': sizeAttribute.toString(),
          if (otherAttribute != null) 'option': {"$otherId": otherValue}
        }));
    if (response.statusCode == 200) {
      Get.back(closeOverlays: true);
      AudioPlayer audioPlayer = AudioPlayer();
      const alarmAudioPath = "assets/sounds/beep.mp3";
      // audioPlayer.play(alarmAudioPath);

      var jsonObject = convert.jsonDecode(response.body);

      if (isRefund.isTrue) {
        if (addToCartList.value.isEmpty) {
          discountAmount = 0.0;
        }
        discountAmount = discountAmount +
            (double.parse(price.toString()) * int.parse(quantity.toString())) *
                double.parse(
                    Get.find<OrderController>().discountNesbat.toString());
      }

      bool contain = Get.find<CartController>()
              .addToCartList
              .value
              .where(
                  (element) => element.itemCode.toString() == iCode.toString())
              .isEmpty
          ? false
          : true;

      if (!contain) {
        addToCartList.value.add(
          CartProductModel(
              mId: jsonObject['data']['cart_item_id'],
              iCode: iCode,
              mPrice: price,
              mQuantity: quantity,
              mTitle: title,
              mTempUniqueId: tempUniqueId,
              pId: int.parse(productId),
              mTitleAr: titleAr,
              mSizeId: sizeAttribute != null ? sizeAttribute.toString() : '',
              mColorId:
                  colorAttribute != null ? colorAttribute.toString() : ''),
        );
      } else {
        switch (optionSc.toString()) {
          case '1':
            bool contain = Get.find<CartController>()
                    .addToCartList
                    .value
                    .where((element) =>
                        element.sizeId.toString() == sizeAttribute.toString() &&
                        element.itemCode.toString() == iCode.toString())
                    .isEmpty
                ? false
                : true;

            if (contain) {
              var current = Get.find<CartController>()
                  .addToCartList
                  .value
                  .where((element) =>
                      element.sizeId.toString() == sizeAttribute.toString() &&
                      element.itemCode.toString() == iCode.toString())
                  .first;
              current.quantity =
                  (int.parse(current.quantity.toString()) + 1).toString();
            } else {
              addToCartList.value.add(
                CartProductModel(
                    mId: jsonObject['data']['cart_item_id'],
                    iCode: iCode,
                    mPrice: price,
                    mQuantity: quantity,
                    mTitle: title,
                    mTempUniqueId: tempUniqueId,
                    pId: int.parse(productId),
                    mTitleAr: titleAr,
                    mSizeId:
                        sizeAttribute != null ? sizeAttribute.toString() : '',
                    mColorId: colorAttribute != null
                        ? colorAttribute.toString()
                        : ''),
              );
            }

            break;
          case '2':
            bool contain = Get.find<CartController>()
                    .addToCartList
                    .value
                    .where((element) =>
                        element.colorId.toString() ==
                            colorAttribute.toString() &&
                        element.itemCode.toString() == iCode.toString())
                    .isEmpty
                ? false
                : true;

            if (contain) {
              var current = Get.find<CartController>()
                  .addToCartList
                  .value
                  .where((element) =>
                      element.colorId.toString() == colorAttribute.toString() &&
                      element.itemCode.toString() == iCode.toString())
                  .first;
              current.quantity =
                  (int.parse(current.quantity.toString()) + 1).toString();
            } else {
              addToCartList.value.add(
                CartProductModel(
                    mId: jsonObject['data']['cart_item_id'],
                    iCode: iCode,
                    mPrice: price,
                    mQuantity: quantity,
                    mTitle: title,
                    mTempUniqueId: tempUniqueId,
                    pId: int.parse(productId),
                    mTitleAr: titleAr,
                    mSizeId:
                        sizeAttribute != null ? sizeAttribute.toString() : '',
                    mColorId: colorAttribute != null
                        ? colorAttribute.toString()
                        : ''),
              );
            }

            break;
          case '3':
            bool contain = Get.find<CartController>()
                    .addToCartList
                    .value
                    .where((element) =>
                        element.sizeId.toString() == sizeAttribute.toString() &&
                        element.colorId.toString() ==
                            colorAttribute.toString() &&
                        element.itemCode.toString() == iCode.toString())
                    .isEmpty
                ? false
                : true;

            if (contain) {
              var current = Get.find<CartController>()
                  .addToCartList
                  .value
                  .where((element) =>
                      element.sizeId.toString() == sizeAttribute.toString() &&
                      element.colorId.toString() == colorAttribute.toString() &&
                      element.itemCode.toString() == iCode.toString())
                  .first;
              current.quantity =
                  (int.parse(current.quantity.toString()) + 1).toString();
            } else {
              addToCartList.value.add(
                CartProductModel(
                    mId: jsonObject['data']['cart_item_id'],
                    iCode: iCode,
                    mPrice: price,
                    mQuantity: quantity,
                    mTitle: title,
                    mTempUniqueId: tempUniqueId,
                    pId: int.parse(productId),
                    mTitleAr: titleAr,
                    mSizeId:
                        sizeAttribute != null ? sizeAttribute.toString() : '',
                    mColorId: colorAttribute != null
                        ? colorAttribute.toString()
                        : ''),
              );
            }

            break;
        }
      }

      totalAmount = double.parse(jsonObject['data']['total_amount'].toString());

      saveCartForSecondMonitor();

      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: 'Done',
          msg: 'Item Added To Cart Successfully',
          bgColor: Colors.green,
          msgColor: Colors.black,
          titleColor: Colors.black,
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
    print(index);
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
      print(jsonObject.toString());

      if (addToCartList.value[index].quantity == '0') {
        addToCartList.value.removeAt(index);
      } else {
        addToCartList.value[index].quantity = quantity.toString();
      }
      totalAmount = double.parse(jsonObject['data']['total_amount'].toString());

      if (isRefund.isTrue) {
        discountAmount = calculateRefundDiscount();
      }
      saveCartForSecondMonitor();
      Get.back(closeOverlays: true);
      update();
    } else {
      Get.back(closeOverlays: true);
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
    print(jsonEncode(<String, String>{
      'id': id.toString(),
      'temp_uniqueid': tempUniqueId,
    }));
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

      double itemQty =
          double.parse(addToCartList.value[index].quantity.toString());
      double itemPrc =
          double.parse(addToCartList.value[index].price.toString());
      double itemPrice = itemQty * itemPrc;
      totalAmount = totalAmount - itemPrice;

      addToCartList.value.removeAt(int.parse(index.toString()));

      saveCartForSecondMonitor();

      if (isRefund.isFalse) {
        if (addToCartList.value.isEmpty) {
          discountAmount = 0.0;
          deliveryAmount = 0.0;
        }
      } else {
        if (addToCartList.value.isEmpty) {
          print(Get.find<OrderController>().orderRefundTotalAmount);
          totalAmount = Get.find<OrderController>().orderRefundTotalAmount +
              Get.find<OrderController>().orderRefundSellerDiscount -
              Get.find<OrderController>().orderRefundDeliveryAmount;
          ;
          discountAmount = double.parse(
              Get.find<OrderController>().orderRefundSellerDiscount.toString());
        } else {
          for (int i = 0; i < addToCartList.value.length; i++) {
            var current = addToCartList.value[i];
            totalAmount = double.parse(current.price.toString());
          }

          discountAmount = calculateRefundDiscount();
        }

        deliveryAmount = Get.find<OrderController>().orderRefundDeliveryAmount;
      }

      Get.back(closeOverlays: true);
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

      if (isRefund.isFalse) {
        addToCartList.value.clear();
        totalAmount = 0.0;
        saveCartForSecondMonitor();
        update();
        Get.find<CartController>().update();

        Get.back(closeOverlays: true);
        discountAmount = 0.0;
        deliveryAmount = 0.0;
        newSale(canTemp: false);
        update();
      } else {
        addToCartList.value.clear();
        totalAmount = Get.find<OrderController>().orderRefundTotalAmount +
            Get.find<OrderController>().orderRefundSellerDiscount -
            Get.find<OrderController>().orderRefundDeliveryAmount;
        discountAmount = Get.find<OrderController>().orderRefundSellerDiscount;
        deliveryAmount = Get.find<OrderController>().orderRefundDeliveryAmount;
        Get.back(closeOverlays: true);
        update();
      }
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
        if (Get.find<CustomerController>().selectedCustomer != null) {
          CustomerAddressDialog.showCustomDialog(title: 'Province & Areas');
        } else {
          AreaProvinceDialog.showCustomDialog(title: 'Province & Areas');
        }
      }
      Get.find<CartController>().update();
    } else {
      Get.back();
      print(response.statusCode);
      // RemoteStatusHandler().errorHandler(
      //     code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  Future<void> checkAdminPassword({required pass}) async {
    LoadingDialog.showCustomDialog(msg: 'Please wait ...');
    var url = CHECK_ADMIN_PASSWORD_ROUTE;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body:
            convert.jsonEncode(<String, String>{'password': pass.toString()}));
    if (response.statusCode == 200) {
      Get.back(closeOverlays: true);
      RefundFactorNumDialog.showCustomDialog(title: 'Refund');
    } else {
      Get.back();
      print(response.statusCode);
      if (response.statusCode == 401) {
        Snack().createSnack(
            title: 'Warning',
            msg: 'You Enter Wrong Password',
            bgColor: Colors.yellow,
            msgColor: Colors.black,
            titleColor: Colors.black);
      } else {
        RemoteStatusHandler().errorHandler(
            code: response.statusCode,
            error: convert.jsonDecode(response.body));
      }
    }
  }

  Future<void> checkoutCart() async {
    CustomerAddressModel address;
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
      'area': Get.find<AddressController>().selectedAddress != null
          ? Get.find<AddressController>().selectedAddress!.areaName.toString()
          : '',
      'block': Get.find<AddressController>().selectedAddress != null
          ? Get.find<AddressController>().selectedAddress!.block.toString()
          : '',
      'street': Get.find<AddressController>().selectedAddress != null
          ? Get.find<AddressController>().selectedAddress!.street.toString()
          : '',
      'house': Get.find<AddressController>().selectedAddress != null
          ? Get.find<AddressController>().selectedAddress!.house.toString()
          : '',
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
          'area': Get.find<AddressController>().selectedAddress != null
              ? Get.find<AddressController>()
                  .selectedAddress!
                  .areaName
                  .toString()
              : '',
          'block': Get.find<AddressController>().selectedAddress != null
              ? Get.find<AddressController>().selectedAddress!.block.toString()
              : '',
          'street': Get.find<AddressController>().selectedAddress != null
              ? Get.find<AddressController>().selectedAddress!.street.toString()
              : '',
          'house': Get.find<AddressController>().selectedAddress != null
              ? Get.find<AddressController>().selectedAddress!.house.toString()
              : '',
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
            iCode: addToCartList.value[i].itemCode,
            pId: addToCartList.value[i].productId,
            mPrice: addToCartList.value[i].price,
            mQuantity: addToCartList.value[i].quantity,
            mTitle: addToCartList.value[i].title,
            mTempUniqueId: addToCartList.value[i].tempUniqueId,
            mTitleAr: addToCartList.value[i].titleAr));
      }

      printedFactorId.value = jsonObject['data']['trackid'];
      var md5FactorId =
          md5.convert(utf8.encode(printedFactorId.value.toString())).toString();

      totalPaidForPrint = double.parse(calController.text.toString());
      totalAmountForPrint = totalAmount;
      deliveryAmountForPrint = deliveryAmount;
      discountAmountForPrint = discountAmount;

      if (Get.find<AddressController>().selectedAddress != null) {
        CustomerAddressModel? value =
            Get.find<AddressController>().selectedAddress;
        customerAddressForPrint =
            '${value!.countryName} ${value.stateName} ${value.areaName} ave:${value.avenue} st:${value.street} house:${value.house} floor:${value.floor} block:${value.block}';
      } else {
        customerAddressForPrint = '';
      }

      addToCartList.value.clear();
      newSale();

      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: 'Done',
          msg: isRefund.isFalse
              ? 'Cart Paid Successfully'
              : 'Cart Refund Successfully',
          duration: 2,
          titleColor: Colors.black,
          bgColor: Colors.green,
          msgColor: Colors.black,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ));
      Get.bottomSheet(
        SuccessModal(
          md5Id: printedFactorId.value.toString(),
        ),
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
              'amount': (totalAmount - discountAmount).toString()
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
      Get.find<OrderController>().orderRefundTotalAmount = 0.0;
      Get.find<OrderController>().orderRefundDeliveryAmount = 0.0;
      Get.find<OrderController>().orderRefundSellerDiscount = 0.0;
      uniqueId = 'pos${Xid()}';
      isRefund.value = false;
      saveCartForSecondMonitor();
      Get.find<ProductController>().productList.value.clear();
      Get.find<ProductController>().getAllProducts(catId: '', keyword: '');

      Get.find<OrderController>().orderList.value.clear();
      Get.find<OrderController>().orderFilteredList.value.clear();
      Get.find<OrderController>().orderItemsList.clear();
      Get.find<OrderController>().hasList.value = false;

      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: 'Done',
          msg: 'Cart Refund Successfully',
          bgColor: Colors.green,
          titleColor: Colors.black,
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
              'amount': (totalAmount - discountAmount).toString(),
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
      Get.find<OrderController>().orderRefundTotalAmount = 0.0;
      Get.find<OrderController>().orderRefundDeliveryAmount = 0.0;
      Get.find<OrderController>().orderRefundSellerDiscount = 0.0;
      uniqueId = 'pos${Xid()}';
      isRefund.value = false;
      saveCartForSecondMonitor();
      Get.find<ProductController>().productList.value.clear();
      Get.find<ProductController>().getAllProducts(catId: '', keyword: '');

      Get.find<OrderController>().orderList.value.clear();
      Get.find<OrderController>().orderFilteredList.value.clear();
      Get.find<OrderController>().orderItemsList.clear();
      Get.find<OrderController>().hasList.value = false;
      Get.back(closeOverlays: true);
      Snack().createSnack(
          title: 'Done',
          msg: 'Cart Item Refund Successfully',
          bgColor: Colors.green,
          titleColor: Colors.black,
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
            iCode: element['item_code'],
            mPrice: element['unitprice'].toString(),
            mQuantity: element['quantity'].toString(),
            mTitle: element['title'],
            mTempUniqueId: uniqueId,
            pId: element['product_id'],
            mTitleAr: element['translate']['ar']));
      });

      if (index != null) openCartsUDID.removeAt(index);
      Get.back(closeOverlays: true);

      totalAmount = double.parse(jsonObject['data']['total'].toString());
      saveCartForSecondMonitor();
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
    }
  }

  void newSale({dynamic canTemp}) {
    if (addToCartList.value.isNotEmpty && isRefund.isFalse) {
      openCartsUDID.add(TempOrderModel(mId: uniqueId));
      addToCartList.value.clear();
      update();
    } else if (addToCartList.value.isNotEmpty && canTemp == true) {
      openCartsUDID.add(TempOrderModel(mId: uniqueId));
      addToCartList.value.clear();
      update();
    }

    totalAmount = 0.0;
    refundCartTotalPrice = '';

    discountAmount = 0.0;
    uniqueId = 'pos${Xid()}';
    deliveryAmount = 0.0;
    selectedCountryName.value = '';
    selectedCountryId = '';
    selectedProvinceName.value = '';
    selectedProvinceId = '';
    selectedAreaName.value = '';
    selectedAreaId = '';
    //isRefund.value = false;
    Get.find<AddressController>().selectedCustomerAddressTitle.value = '';
    Get.find<AddressController>().selectedCustomerAddressId = '';
    Get.find<AddressController>().selectedAddress = null;
    Get.find<CustomerController>().selectedCustomerName.value = '';
    Get.find<CustomerController>().selectedCustomer = null;
    Get.find<CustomerController>().customerNameController.text = '';
    Get.find<CustomerController>().customerEmailController.text = '';
    Get.find<CustomerController>().customerNumberController.text = '';
    Get.find<CustomerController>().customerController.text = '';
    Get.find<CustomerController>().customerController.text = '';
    addToCartList.value.clear();
    Get.find<OrderController>().orderRefundTotalAmount = 0.0;
    Get.find<OrderController>().orderRefundDeliveryAmount = 0.0;
    Get.find<OrderController>().orderRefundSellerDiscount = 0.0;
    update();
  }

  void saveCartForSecondMonitor() {
    addToCartJson = {
      'subTotal': totalAmount.toString(),
      'discount': discountAmount.toString(),
      'delivery': deliveryAmount.toString(),
      'isRefund': isRefund.value,
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
    if (addToCartList.value.isEmpty && isRefund.isFalse) {
      LocalStorageHelper.removeValue('cartData');
    }
  }

  Future<Uint8List> generatePdf() async {
    var coData = Get.find<AuthController>().coDetails;
    final pdf = pw.Document();
    final gf = await PdfGoogleFonts.iBMPlexSansArabicLight();

    final barcode = Barcode.code128();
    final svg = barcode.toSvg(printedFactorId.value.toString(),
        width: 100, drawText: false, height: 50);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(
                  child: pw.Text('INVOICE NO #${printedFactorId.value}',
                      style: pw.TextStyle(
                          fontSize: 15, fontWeight: pw.FontWeight.bold))),
              pw.Center(
                  child: pw.Text(
                coData['name_en'],
              )),
              pw.Center(
                  child: pw.Text(
                coData['address_en'],
              )),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Center(
                    child: pw.Text(
                  'Phone: ' + coData['phone'],
                )),
                pw.SizedBox(width: 10),
                pw.Center(
                    child: pw.Text(
                  'Mobile: ' + coData['mobile'],
                )),
              ]),
              pw.Center(
                  child: pw.Text(
                Get.find<AuthController>().webSite,
              )),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Center(
                        child: pw.Text(
                      'Cashier: ${Get.find<UserController>().name}',
                    )),
                    pw.Column(children: [
                      pw.Center(
                        child: pw.Text(
                          DateTime.now().year.toString() +
                              '-' +
                              DateTime.now().month.toString() +
                              '-' +
                              DateTime.now().day.toString(),
                        ),
                      ),
                      pw.Center(
                        child: pw.Text(
                          DateTime.now().hour.toString() +
                              ':' +
                              DateTime.now().minute.toString(),
                        ),
                      )
                    ])
                  ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                pw.Expanded(
                    flex: 1,
                    child:
                        pw.Text('#', style: const pw.TextStyle(fontSize: 10))),
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
                                      pw.Text(
                                        currentItem.title.toString(),
                                        maxLines: 1,
                                        textAlign: pw.TextAlign.left,
                                        textDirection: pw.TextDirection.ltr,
                                        style: const pw.TextStyle(fontSize: 10),
                                        overflow: pw.TextOverflow.clip,
                                      ),
                                      pw.Text(currentItem.titleAr.toString(),
                                          maxLines: 1,
                                          textAlign: pw.TextAlign.right,
                                          textDirection: pw.TextDirection.rtl,
                                          style: pw.TextStyle(
                                              font: gf, fontSize: 10)),
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
                                  double.parse(
                                    currentItem.price.toString(),
                                  ).toStringAsFixed(3),
                                  style: const pw.TextStyle(fontSize: 10)),
                            ),
                            pw.SizedBox(
                              width: 2,
                            ),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(itemPrice.toStringAsFixed(3),
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
                    pw.Text(
                      'Subtotal: ',
                    ),
                    pw.Text(
                      totalAmountForPrint.toStringAsFixed(3),
                    ),
                  ]),
              pw.Divider(thickness: 2),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Qty: ${addToCartListForPrint.length}',
                    ),
                    pw.Text(
                      'Delivery: ${deliveryAmountForPrint.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Discount: ${discountAmountForPrint.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Total:  ${(totalAmountForPrint - discountAmountForPrint + deliveryAmountForPrint).toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Paid: ${totalPaidForPrint.toStringAsFixed(3)}',
                    ),
                  ]),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(),
                    pw.Text(
                      'Balance: ${(totalPaidForPrint - (totalAmountForPrint - discountAmountForPrint + deliveryAmountForPrint)).toStringAsFixed(3)}',
                    ),
                  ]),
              pw.SizedBox(height: 25),
              Get.find<CartController>().customerAddressForPrint != ''
                  ? pw.Center(
                      child: pw.Text(
                      'Address: ' +
                          Get.find<CartController>().customerAddressForPrint,
                    ))
                  : pw.SizedBox(),
              pw.SizedBox(height: 12),
              pw.SvgImage(svg: svg),
              pw.SizedBox(height: 25),
              pw.Center(
                  child: pw.Text(
                coData['pos_note_en'] ?? 'Thanks For Your Purchase',
              ))
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> openDrawer() async {
    final pdf = pw.Document();

    return pdf.save();
  }

  double calculateRefundDiscount() {
    double discount = 0.0;
    double total = 0.0;
    if (isRefund.isTrue) {
      for (int i = 0; i < addToCartList.value.length; i++) {
        discount = (double.parse(addToCartList.value[i].price.toString()) *
                int.parse(addToCartList.value[i].quantity.toString())) *
            double.parse(Get.find<OrderController>().discountNesbat.toString());
        total = total + discount;
      }
    }
    print(total);
    return total;
  }
}
