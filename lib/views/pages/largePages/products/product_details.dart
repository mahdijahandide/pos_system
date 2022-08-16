import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/product_controller.dart';

import '../../../../services/model/product_color_model.dart';
import '../../../../services/model/product_others_model.dart';
import '../../../../services/model/product_size_model.dart';
import '../../../components/texts/customText.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key, dynamic title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.close(1);
              Get.toNamed(Get.parameters['popRoute'].toString());
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: Get.arguments['title'],
            size: 18,
            fontWeight: FontWeight.bold),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: Get.width,
            height: 350,
            child: CarouselSlider.builder(
              itemCount: Get.arguments['gallery'].length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      SizedBox(
                width: Get.width,
                height: 150,
                child: Image(
                  image: NetworkImage(
                      Get.arguments['gallery'][itemIndex]['large']),
                  fit: BoxFit.fill,
                ),
              ),
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CustomText().createText(
                title: 'About', fontWeight: FontWeight.bold, size: 22),
          ),
          Container(
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              color: Colors.white,
              child: CustomText().createText(
                  title: Get.arguments['details_ios'],
                  size: 22,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CustomText().createText(
              title: 'Details',
              fontWeight: FontWeight.bold,
              size: 22,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              color: Colors.white,
              child: Column(
                children: [
                  CustomText().createSpaceKeyVal(
                      keyText: 'Quantity: ',
                      valText: Get.arguments['quantity'].toString(),
                      valFontWeight: FontWeight.bold,
                      keySize: 20,
                      valSize: 20),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText().createSpaceKeyVal(
                      keyText: 'Retail Price: ',
                      valText:
                          Get.arguments['retail_price'].toStringAsFixed(3) +
                              ' KD',
                      valFontWeight: FontWeight.bold,
                      keySize: 20,
                      valSize: 20),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText().createSpaceKeyVal(
                      keyText: 'Old Price: ',
                      valText:
                          Get.arguments['old_price'].toStringAsFixed(3) + ' KD',
                      valFontWeight: FontWeight.bold,
                      keySize: 20,
                      valSize: 20),
                ],
              )),
          const SizedBox(
            height: 25,
          ),
          Get.arguments['options']['section_id'] == 0
              ? const SizedBox()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: CustomText().createText(
                        title: 'Options',
                        fontWeight: FontWeight.bold,
                        size: 22,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 25),
                        color: Colors.white,
                        child: optionWidget()),
                  ],
                )
        ],
      ),
    );
  }

  Widget optionWidget() {
    switch (Get.arguments['options']['section_id']) {
      case 1:
        var sizeArray = Get.arguments['options']['sizes'];
        String title = '';
        Get.find<ProductController>().productSizeList.clear();
        sizeArray.forEach((element) {
          Get.find<ProductController>()
              .productSizeList
              .add(ProductSizeModel(data: element));
          title = title + ' ' + element['size_name'].toString();
        });
        return CustomText().createSpaceKeyVal(
            keyText: 'Available Sizes: ',
            valText: title,
            valFontWeight: FontWeight.bold,
            keySize: 20,
            valSize: 20);
      case 2:
        var colorArray = Get.arguments['options']['colors'];
        String title = '';
        Get.find<ProductController>().productColorList.clear();
        colorArray.forEach((element) {
          Get.find<ProductController>()
              .productColorList
              .add(ProductColorModel(data: element));
          title = title + ' ' + element['color_name'].toString();
        });
        return CustomText().createSpaceKeyVal(
            keyText: 'Available Colors: ',
            valText: title,
            valFontWeight: FontWeight.bold,
            keySize: 20,
            valSize: 20);
      case 3:
        return Container();
      case 4:
        var othersObj = Get.arguments['options']['others'];
        String title = '';
        var type = othersObj['type'];
        var isRequired = othersObj['is_required'];
        var otherId = othersObj['id'];
        var valuesArray = othersObj['values'];
        Get.find<ProductController>().productOthersList.clear();
        valuesArray.forEach((element) {
          Get.find<ProductController>()
              .productOthersList
              .add(ProductOthersModel(data: element));
          title = title + ' ' + element['title'].toString();
        });
        return CustomText().createSpaceKeyVal(
            keyText: 'Available Options: ',
            valText: title,
            valFontWeight: FontWeight.bold,
            keySize: 20,
            valSize: 20);
    }
    return const SizedBox();
  }
}
