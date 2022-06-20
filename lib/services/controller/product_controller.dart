import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/model/product_color_model.dart';
import 'package:pos_system/services/model/product_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/model/product_others_model.dart';
import 'package:pos_system/services/model/product_size_color_model.dart';
import 'package:pos_system/services/model/product_size_model.dart';
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/components/snackbar/snackbar.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:pos_system/views/dialogs/product_type1_dialog.dart';
import 'package:pos_system/views/dialogs/product_type2_dialog.dart';
import 'package:pos_system/views/dialogs/product_type3_dialog.dart';
import 'package:pos_system/views/dialogs/product_type4_select_dialog.dart';
import 'package:pos_system/views/pages/largePages/products/products_modal.dart';

import '../remotes/remote_status_handler.dart';

class ProductController extends GetxController {
  Rx<List<ProductModel>> productList = Rx<List<ProductModel>>([]);
  List<ProductModel> searchedProductList = [];
  List<ProductColorModel> productColorList = [];
  List<ProductSizeModel> productSizeList = [];
  List<ProductSizeColorModel> productSizeColorList = [];
  List<ProductOthersModel> productOthersList = [];
  RxBool hasProduct = false.obs;
  RxString selectedColorName = ''.obs;
  RxString selectedValue = ''.obs;
  RxString selectedSizeName = ''.obs;
  late String selectedColorId;
  late String selectedValueId;
  late String selectedSizeId;
  RxInt overlaysCounter = 0.obs;

  int gridCtn() {
    update();
    return Get.width <= 600
        ? 2
        : Get.width > 600 && Get.width < 900
            ? 3
            : 4;
  }

  Future<void> getAllProducts(
      {required catId,
      required keyword,
      dynamic openModal,
      dynamic openModalTap,
      dynamic title}) async {
    if(openModal!=true){
      productList.value.clear();
      update();
    }
    if(Get.find<DashboardController>().isShowKeyboard.isTrue){Get.find<DashboardController>().isShowKeyboard.value=false;
    Get.find<DashboardController>().update();
    }
    Get.find<DashboardController>().searchController.text='';

    var url = PRODUCTS_BY_CATEGORIES_ROUTE;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}',
          // 'Access-Control-Allow-Origin':'*'
        },
        body: jsonEncode(<String, String>{'catid': catId, 'keyword': keyword}));
    if (response.statusCode == 200) {
      hasProduct.value = true;
      var jsonObject = convert.jsonDecode(response.body);
      var productArray = jsonObject['data']['productLists'];
      if (openModal == true) {
        searchedProductList.clear();
        productArray.forEach((element) {
          searchedProductList.add((ProductModel(data: element)));
        });
        Get.back();
        Get.bottomSheet(
          ProductsModal(
            ontap: openModalTap,
            gridCnt: Get.width < 600
                ? 2
                : Get.width > 600 && Get.width < 900
                    ? 3
                    : 5,
            title: title.toString(),
            current: searchedProductList,
            isProduct: true,
            listCount: searchedProductList.length,
          ),
          isScrollControlled: true,
          enableDrag: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        );
      } else {
        productArray.forEach((element) {
          productList.value.add((ProductModel(data: element)));
        });
      }
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  Future<void> getProductDetails(
      {required productId,
      dynamic openModal,
      dynamic title,
      dynamic showDetails}) async {
    LoadingDialog.showCustomDialog(msg: 'please wait ...');
    var url = PRODUCT_DETAILS_ROUTE;
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}'
        },
        body: jsonEncode(<String, dynamic>{
          'product_id': productId.toString(),
        }));
    if (response.statusCode == 200) {
      productColorList.clear();
      productSizeList.clear();
      Get.back();
      hasProduct.value = true;
      var jsonObject = convert.jsonDecode(response.body);
      var productDetails = jsonObject['data']['productDetails'];
      var optionsArray = jsonObject['data']['productDetails']['options'];
      if (showDetails != null) {
        Get.toNamed('/productDetails', arguments: productDetails);
      } else {
        switch (optionsArray['section_id']) {
          case 1:
            var sizeArray = optionsArray['sizes'];
            productSizeList.clear();
            sizeArray.forEach((element) {
              productSizeList.add(ProductSizeModel(data: element));
            });
            selectedSizeName = 'select Size'.obs;
            selectedSizeId = '';
            ProductOptionDialog1.showCustomDialog(
                title: title, productId: productId);
            break;
          case 2:
            var colorArray = optionsArray['colors'];
            productColorList.clear();
            colorArray.forEach((element) {
              productColorList.add(ProductColorModel(data: element));
            });
            selectedColorName = 'select color'.obs;
            selectedColorId = '';
            ProductOptionDialog2.showCustomDialog(
                title: title, productId: productId);
            break;
          case 3:
            var sizeColorArray = optionsArray['sizes_colors'];
            productSizeColorList.clear();
            sizeColorArray.forEach((element) {
              productSizeColorList.add(ProductSizeColorModel(data: element));
            });
            selectedColorName = 'select color'.obs;
            selectedColorId = '';
            selectedSizeName = 'select size'.obs;
            selectedSizeId = '';
            ProductOptionDialog3.showCustomDialog(
              title: title,
              productId: productId,
            );
            break;
          case 4:
            var othersObj = optionsArray['others'];
            var title = othersObj['title'];
            var type = othersObj['type'];
            var isRequired = othersObj['is_required'];
            var otherId = othersObj['id'];
            var valuesArray = othersObj['values'];
            productOthersList.clear();
            valuesArray.forEach((element) {
              productOthersList.add(ProductOthersModel(data: element));
            });
            selectedValue = 'select value'.obs;
            selectedValueId = '';
            if (type == "radio" || type == "select") {
              ProductTypeSelect.showCustomDialog(
                title: title,
                productId: productId,
                isRequired: isRequired,
                type: type,
                otherId: otherId,
              );
            } else if (type == "checkbox") {
              ProductTypeSelect.showCustomDialog(
                title: title,
                productId: productId,
                isRequired: isRequired,
                type: type,
                otherId: otherId,
              );
            }
            break;
          default:
            Snack().createSnack(
                title: 'Warning',
                msg: 'Can Not Add This Item To Cart At This Moment',
                bgColor: Colors.red);
            break;
        }
        update();
      }
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(
          code: response.statusCode, error: convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  void closeOverlays(int count) {
    for (int i = 0; i < count; i++) {
      Get.back();
    }
    overlaysCounter.value = 0;
  }
}
