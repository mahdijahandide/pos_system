import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/views/components/texts/customText.dart';


class CashModal extends StatelessWidget {
  String title ;
  CashModal({Key? key,required this.title,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: Colors.white,
          child: ListView(
              physics:const BouncingScrollPhysics(),
              children: [
            Container(width: Get.width,color: Colors.grey.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  CustomText().createText(
                      title: title,
                      size: 18,color: Colors.black,
                      fontWeight: FontWeight.bold),
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 23,
                  ))
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 15,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                            spreadRadius: 1)
                      ]),
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: Get.width,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Center(child: CustomText().createText(title: 'Removed',align: TextAlign.center,color: Colors.white,size: 22,fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 15,),
                                  CustomText().createText(title: '- 500 KD',size: 22,fontWeight: FontWeight.bold,color: Colors.black)
                                ],
                              ),
                              CustomText().createText(title: 'Date: 2022/12/12',size: 22,color: Colors.black),
                              CustomText().createText(title: 'By : John snow ',size: 22,color: Colors.black),

                            ],
                          ),
                        ),
                      ),
                      ExpansionTile(
                        textColor: Colors.black12,
                        trailing: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.black,
                        ),
                        title: ListTile(
                          title: CustomText().createText(
                              title: 'Show Description',
                              size: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: CustomText().createText(title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ]),
        ));
  }
}
