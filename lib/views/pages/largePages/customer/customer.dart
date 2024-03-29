import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/address_controller.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/views/dialogs/delete_dialog.dart';
import 'package:pos_system/views/pages/largePages/customer/add_customer_modal.dart';
import 'package:pos_system/views/pages/largePages/modals/update_user_address_modal.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../../components/texts/customText.dart';

class Customer extends GetView<CustomerController> {
  const Customer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.customerList.isEmpty) {
      controller.getCustomers(hasLoading: false, doInBackground: true);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.close(1);
            Get.offNamed('/dashboard', preventDuplicates: false);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.withOpacity(0.5),
        title: CustomText().createText(
            title: 'Customers'.tr, size: 18, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
              onPressed: () async {
                if (Get.find<CartController>().countryList.isEmpty) {
                  await Get.find<CartController>().getAreas(
                    doInBackground: true,
                  );
                }
                Get.bottomSheet(AddCustomerModal().createModal(),
                    isScrollControlled: true, ignoreSafeArea: false);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Obx(
        () => controller.hasCustomer.isFalse
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 15),
                    child: TextField(
                      controller: controller.customerController,
                      //focusNode: controller.,
                      onChanged: (value) => controller.filterPlayer(value),
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.foundPlayers.value.length,
                        itemBuilder: (context, index) {
                          var currentItem =
                              controller.foundPlayers.value[index];
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12.withOpacity(0.3),
                                      offset: const Offset(1, 1),
                                      blurRadius: 3,
                                      spreadRadius: 1)
                                ]),
                            margin: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 15),
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CustomText().createText(
                                            title: currentItem.name ?? '',
                                            size: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)
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
                                  onExpansionChanged: (e) {
                                    if (e == true &&
                                        currentItem.addressList.isEmpty) {
                                      Get.find<AddressController>()
                                          .getCustomerAddressRequest(
                                              customerId:
                                                  currentItem.id.toString());
                                    }
                                  },
                                  title: ListTile(
                                    title: CustomText().createText(
                                        title: 'Show Details',
                                        size: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText().createText(
                                                  title:
                                                      'Mobile: ${currentItem.mobile ?? ''}',
                                                  size: 22,
                                                  color: Colors.black),
                                              CustomText().createText(
                                                  title:
                                                      'Email: ${currentItem.email ?? ''}',
                                                  size: 22,
                                                  color: Colors.black),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    GetX(
                                      builder: (AddressController controller) {
                                        return currentItem.hasAddress.isFalse
                                            ? const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : ListView.builder(
                                                itemCount: currentItem
                                                    .addressList.value.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  var currentAddress =
                                                      currentItem.addressList
                                                          .value[index];
                                                  return ListTile(
                                                      title: CustomText()
                                                          .createText(
                                                              title:
                                                                  currentAddress
                                                                      .title,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      subtitle: CustomText()
                                                          .createText(
                                                              title:
                                                                  '${currentAddress.countryName}  ${currentAddress.stateName}  ${currentAddress.areaName} avenue:${currentAddress.avenue} street:${currentAddress.street} house:${currentAddress.house} floor:${currentAddress.floor} block:${currentAddress.block}',
                                                              color:
                                                                  Colors.black),
                                                      trailing: PopupMenuButton(
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  <PopupMenuEntry>[
                                                                    PopupMenuItem(
                                                                      value:
                                                                          'update',
                                                                      child: ListTile(
                                                                          onTap: () async {
                                                                            if (Get.find<CartController>().countryList.isEmpty) {
                                                                              await Get.find<CartController>().getAreas(
                                                                                doInBackground: true,
                                                                              );
                                                                            }
                                                                            Get.bottomSheet(UpdateUserModal().createModal(userId: currentItem.id.toString(), addressId: currentAddress.id.toString(), areaNameTxt: currentAddress.areaName.toString(), areaId: currentAddress.areaId.toString(), avenueTxt: currentAddress.avenue.toString(), blockTxt: currentAddress.block.toString(), countryId: currentAddress.countryId.toString(), countryNameTxt: currentAddress.countryName.toString(), floorTxt: currentAddress.floor.toString(), houseTxt: currentAddress.house.toString(), stateId: currentAddress.stateId.toString(), stateNameTxt: currentAddress.stateName.toString(), streetTxt: currentAddress.stateName.toString(), titleTxt: currentAddress.title.toString()),
                                                                                isScrollControlled: true,
                                                                                ignoreSafeArea: false);
                                                                          },
                                                                          leading: const Icon(
                                                                            Icons.edit,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          title: Text(
                                                                            'update'.tr,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.black,
                                                                            ),
                                                                          )),
                                                                    ),
                                                                    PopupMenuItem(
                                                                      value:
                                                                          'delete',
                                                                      child: ListTile(
                                                                          onTap: () {
                                                                            Get.back();
                                                                            DeleteDialog.showCustomDialog(
                                                                                title: 'Warning',
                                                                                msg: 'Deleting Customer Address?',
                                                                                addressId: currentAddress.id.toString(),
                                                                                customerId: currentItem.id.toString());
                                                                          },
                                                                          leading: const Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          title: Text(
                                                                            'delete'.tr,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.black,
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  ]));
                                                },
                                              );
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
      // bottomNavigationBar: Obx(
      //   () => Get.find<CustomerController>().isShowKeyboard.isTrue
      //       ? Container(
      //           height: 350,
      //           color: const Color(0xffeeeeee),
      //           child: VirtualKeyboard(
      //               focusNode: FocusNode(),
      //               textColor: Colors.black,
      //               type: VirtualKeyboardType.Alphanumeric,
      //               textController:
      //                   Get.find<CustomerController>().customerController),
      //         )
      //       : const SizedBox(),
      // )
    );
  }
}
