import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/helper/app_color.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:shimmer/shimmer.dart';


class ProductShimmer{
  Widget createProductShimmer({required gridCnt, dynamic key, dynamic isLarge}){
    return GetBuilder(
        builder: (DashboardController controller) {
          return Column(
            children: [
              IntrinsicHeight(
                child: isLarge == true ? Row(
                  children: [
                    const SizedBox(
                      width: 6,
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColor.SHIMMER_BG,
                      highlightColor: AppColor.SHIMMER_FG,
                      child: Icon(Icons.qr_code_scanner, size: 45,
                        color: controller.searchId.value.isEqual(1) ? Colors
                            .blue : Colors.black,),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const VerticalDivider(),
                    const SizedBox(
                      width: 6,
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColor.SHIMMER_BG,
                      highlightColor: AppColor.SHIMMER_FG,
                      child: CustomText().createText(title: '123',
                        fontWeight: FontWeight.bold,
                        size: 20,
                        color: controller.searchId.value.isEqual(2) ? Colors
                            .blue : Colors.black,),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const VerticalDivider(),
                    const SizedBox(
                      width: 6,
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColor.SHIMMER_BG,
                      highlightColor: AppColor.SHIMMER_FG,
                      child: Icon(Icons.label, size: 45,
                        color: controller.searchId.value.isEqual(3) ? Colors
                            .blue : Colors.black,),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const VerticalDivider(),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                        child: Shimmer.fromColors(
                          baseColor: AppColor.SHIMMER_BG,
                          highlightColor: AppColor.SHIMMER_FG,
                          child: Container(height: 60.0,width: Get.width,color: Colors.white,),
                        )),
                    const SizedBox(
                      width: 6,
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColor.SHIMMER_BG,
                      highlightColor: AppColor.SHIMMER_FG,
                      child: Icon(Icons.keyboard, size: 45,
                          color: controller.isShowKeyboard.isTrue ? Colors
                              .blue : Colors.black),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ) :
                Shimmer.fromColors(
                  baseColor: AppColor.SHIMMER_BG,
                  highlightColor: AppColor.SHIMMER_FG,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 3,
                      ),
                      InkWell(
                          onTap: () {
                            key.currentState!.openDrawer();
                          },
                          child: const Icon(Icons.menu, size: 30,)),
                      const SizedBox(
                        width: 3,
                      ),
                      const VerticalDivider(),
                      PopupMenuButton(
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry>[
                            PopupMenuItem(
                              child: ListTile(
                                  onTap: (){controller.changeSearchType(id: 1);Get.back();},
                                  leading: Icon(Icons.qr_code_scanner,color: controller.searchId.value.isEqual(1) ? Colors
                                      .blue : Colors.black,),
                                  title: Text('Search By Barcode',style: TextStyle(color: controller.searchId.value.isEqual(1) ? Colors
                                      .blue : Colors.black,),)),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                  onTap: (){controller.changeSearchType(id: 2);Get.back();},
                                  leading: Text('123',style: TextStyle(color: controller.searchId.value.isEqual(2) ? Colors
                                      .blue : Colors.black,),),
                                  title: Text('Search By Code',style: TextStyle(color: controller.searchId.value.isEqual(2) ? Colors
                                      .blue : Colors.black,),)),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                  onTap: (){controller.changeSearchType(id: 3);Get.back();},
                                  leading: Icon(Icons.label,color: controller.searchId.value.isEqual(3) ? Colors
                                      .blue : Colors.black,),
                                  title: Text('Search By Name',style: TextStyle(color: controller.searchId.value.isEqual(3) ? Colors
                                      .blue : Colors.black,),)),
                            ),
                          ]),

                      const VerticalDivider(),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                          child: CustomTextField().createTextField(
                              hint: controller.searchId.value.isEqual(1)
                                  ? 'search product by barcode'
                                  : controller.searchId.value.isEqual(3)
                                  ? 'search product by name':'search product by code',
                              controller: Get
                                  .find<DashboardController>()
                                  .searchController,
                              height: 60.0,
                              align: TextAlign.start,
                              hasSuffixIcon: true)),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCnt,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors
                          .grey.withOpacity(0.5), width: 1.5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Shimmer.fromColors(highlightColor: AppColor.SHIMMER_FG,
                              baseColor: AppColor.SHIMMER_BG,child: Container(color: Colors.white,))),
                          const SizedBox(height: 15.0,),
                          Shimmer.fromColors(
                            highlightColor: AppColor.SHIMMER_FG,
                            baseColor: AppColor.SHIMMER_BG,
                            child: Container(color: Colors.white,
                            width: 150.0,height: 15.0,),
                          ),
                          const SizedBox(height: 10.0,),
                          Shimmer.fromColors(
                            highlightColor: AppColor.SHIMMER_FG,
                            baseColor: AppColor.SHIMMER_BG,
                            child: Container(color: Colors.white,
                              width: 80.0,height: 15.0,),
                          ),
                          const SizedBox(height: 10.0,),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
    );
  }
}