import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';
import 'package:pos_system/services/model/category_model.dart';
import 'package:pos_system/services/model/product_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/services/remotes/api_routes.dart';
import 'package:pos_system/views/dialogs/loading_dialogs.dart';
import 'package:pos_system/views/pages/largePages/products/products_modal.dart';

import '../remotes/remote_status_handler.dart';


class CategoryController extends GetxController {
  List<CategoryModel>categoryList = [];
  List<ProductModel>categoryProductList = [];
  RxBool hasCategory = false.obs;

  Future<void> getAllCategory() async {
    var url = GET_ALL_CATEGORIES_ROUTE;
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get
            .find<AuthController>()
            .token}'
      },
    );
    if (response.statusCode == 200) {
      hasCategory.value = true;
      var jsonObject = convert.jsonDecode(response.body);
      var categoryArray = jsonObject['data'];
      categoryList.clear();
      categoryArray.forEach((element) {
        categoryList.add((CategoryModel(data: element)));
      });
      update();
    } else {
      Get.back();
      RemoteStatusHandler().errorHandler(code: response.statusCode,error:convert.jsonDecode(response.body));
      print(response.body);
    }
  }
}