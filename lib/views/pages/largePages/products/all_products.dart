import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/views/pages/largePages/dashboard/widget/dashboard_main.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../components/texts/customText.dart';

class AllProduct extends StatelessWidget {
  int gridCtn;
  AllProduct({Key? key,required this.gridCtn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: 'All Products'.tr, size: 18, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ScreenTypeLayout(
          desktop:  DashboardMain().createMain(gridCnt: 5,noSideBar: true,ontap: true),
          tablet:   DashboardMain().createMain(gridCnt: 3,noSideBar: true,ontap: true),
          mobile:   DashboardMain().createMain(gridCnt: 2,noSideBar: true,ontap: true,),
          watch:    Container(color:Colors.white),
        )
      ),
    );
  }
}
