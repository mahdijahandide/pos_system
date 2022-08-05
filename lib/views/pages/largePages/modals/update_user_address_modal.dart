import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/address_controller.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../../../services/controller/cart_controller.dart';
import '../../../../services/model/area_model.dart';
import '../../../../services/model/city_model.dart';
import '../../../../services/model/province_model.dart';
import '../../../components/buttons/custom_text_button.dart';
import '../../../components/textfields/textfield.dart';
import '../../../components/texts/customText.dart';

class UpdateUserModal {
  FocusNode title = FocusNode();
  FocusNode block = FocusNode();
  FocusNode street = FocusNode();
  FocusNode avenue = FocusNode();
  FocusNode houseApartment = FocusNode();
  FocusNode floor = FocusNode();

  final ScrollController _controller = ScrollController();

  Widget createModal(
      {required String userId,
      required String addressId,
      required String titleTxt,
      required String countryId,
      required String countryNameTxt,
      required String stateId,
      required String stateNameTxt,
      required String areaId,
      required String areaNameTxt,
      required String blockTxt,
      required String streetTxt,
      required String avenueTxt,
      required String houseTxt,
      required String floorTxt}) {
    Get.find<AddressController>().titleController.text = titleTxt;
    Get.find<AddressController>().blockController.text = blockTxt;
    Get.find<AddressController>().streetController.text = streetTxt;
    Get.find<AddressController>().avenueController.text = avenueTxt;
    Get.find<AddressController>().houseApartmanController.text = houseTxt;
    Get.find<AddressController>().floorController.text = floorTxt;
    Get.find<CartController>().selectedNewCountryId = countryId.toString();
    Get.find<CartController>().selectedNewProvinceId = stateId.toString();
    Get.find<CartController>().selectedNewAreaId = areaId.toString();
    Get.find<CartController>().selectedNewCountryName.value =
        countryNameTxt.toString();
    Get.find<CartController>().selectedNewProvinceName.value =
        stateNameTxt.toString();
    Get.find<CartController>().selectedNewAreaName.value =
        areaNameTxt.toString();

    return GestureDetector(
      onTap: () {
        Get.find<AddressController>().focusTitle.value = false;
        Get.find<AddressController>().focusBlock.value = false;
        Get.find<AddressController>().focusStreet.value = false;
        Get.find<AddressController>().focusAvenue.value = false;
        Get.find<AddressController>().focusHouseApartment.value = false;
        Get.find<AddressController>().focusFloor.value = false;
      },
      child: Container(
          color: const Color(0xfffcfcfc),
          child: Obx(() {
            return SingleChildScrollView(
              controller: _controller,
              reverse: true,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: Colors.grey.withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        CustomText().createText(
                            title: 'Customer Address',
                            size: 18,
                            fontWeight: FontWeight.bold),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 23,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width / 1.48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'Title'),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextField().createTextField(
                                    hint: '',
                                    height: 50,
                                    node: title,
                                    onTap: () {
                                      Get.find<AddressController>()
                                              .focusTitle
                                              .value =
                                          !Get.find<AddressController>()
                                              .focusTitle
                                              .value;
                                      Get.find<AddressController>()
                                          .focusBlock
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusAvenue
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusStreet
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusFloor
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusHouseApartment
                                          .value = false;
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 100),
                                          curve: Curves.easeOut);
                                    },
                                    controller: Get.find<AddressController>()
                                        .titleController)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'Country'),
                                const SizedBox(
                                  height: 6,
                                ),
                                //country
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1.2,
                                          color: Colors.grey.withOpacity(0.5))),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      focusColor: Colors.white,
                                      hint: Text(Get.find<CartController>()
                                          .selectedNewCountryName
                                          .toString()),
                                      onChanged: (val) {
                                        Get.find<CartController>()
                                                .selectedNewCountryId =
                                            val.toString();
                                        Get.find<CartController>()
                                                .selectedNewCountryName
                                                .value =
                                            Get.find<CartController>()
                                                .countryList
                                                .where((element) =>
                                                    element.id ==
                                                    int.parse(val.toString()))
                                                .first
                                                .name!;
                                        Get.find<CartController>()
                                            .selectedNewProvinceId = '';
                                        Get.find<CartController>()
                                            .selectedNewAreaId = '';
                                        Get.find<CartController>()
                                            .selectedNewProvinceName
                                            .value = '';
                                        Get.find<CartController>()
                                            .selectedNewAreaName
                                            .value = '';
                                        Get.find<CartController>().update();
                                      },
                                      items: Get.find<CartController>()
                                          .countryList
                                          .map((ProvinceModel value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id.toString(),
                                          child: Text(value.name.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'State'),
                                const SizedBox(
                                  height: 6,
                                ),
                                //province
                                Get.find<CartController>()
                                            .selectedNewCountryId ==
                                        ''
                                    ? Container(
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1.2,
                                                color: Colors.grey
                                                    .withOpacity(0.5))),
                                      )
                                    : Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1.2,
                                                color: Colors.grey
                                                    .withOpacity(0.5))),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            focusColor: Colors.white,
                                            isExpanded: true,
                                            hint: Text(
                                                Get.find<CartController>()
                                                    .selectedNewProvinceName
                                                    .toString()),
                                            onChanged: (val) {
                                              Get.find<CartController>()
                                                      .selectedNewProvinceId =
                                                  val.toString();
                                              Get.find<CartController>()
                                                  .selectedNewProvinceName
                                                  .value = Get.find<
                                                      CartController>()
                                                  .countryList
                                                  .where((element) =>
                                                      element.name ==
                                                      Get.find<CartController>()
                                                          .selectedNewCountryName
                                                          .value)
                                                  .first
                                                  .provinceList
                                                  .where((element) =>
                                                      element.id ==
                                                      int.parse(val.toString()))
                                                  .first
                                                  .name
                                                  .toString();
                                              Get.find<CartController>()
                                                  .selectedNewAreaId = '';
                                              Get.find<CartController>()
                                                  .selectedNewAreaName
                                                  .value = '';
                                              Get.find<CartController>()
                                                  .update();
                                            },
                                            items: Get.find<CartController>()
                                                .countryList
                                                .where((element) =>
                                                    element.name ==
                                                    Get.find<CartController>()
                                                        .selectedNewCountryName
                                                        .toString())
                                                .first
                                                .provinceList
                                                .map((CityModel value) {
                                              return DropdownMenuItem<String>(
                                                value: value.id.toString(),
                                                child:
                                                    Text(value.name.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'Area'),
                                const SizedBox(
                                  height: 6,
                                ),
                                //area
                                Get.find<CartController>()
                                            .selectedNewProvinceId ==
                                        ''
                                    ? Container(
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1.2,
                                                color: Colors.grey
                                                    .withOpacity(0.5))),
                                      )
                                    : Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1.2,
                                                color: Colors.grey
                                                    .withOpacity(0.5))),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            focusColor: Colors.white,
                                            isExpanded: true,
                                            hint: Text(
                                                Get.find<CartController>()
                                                    .selectedNewAreaName
                                                    .toString()),
                                            onChanged: (val) {
                                              Get.find<CartController>()
                                                      .selectedNewAreaId =
                                                  val.toString();

                                              Get.find<CartController>()
                                                  .selectedNewAreaName
                                                  .value = Get.find<
                                                      CartController>()
                                                  .countryList
                                                  .where((element) =>
                                                      element.name ==
                                                      Get.find<CartController>()
                                                          .selectedNewCountryName
                                                          .value)
                                                  .first
                                                  .provinceList
                                                  .where((element) =>
                                                      element.id.toString() ==
                                                      Get.find<CartController>()
                                                          .selectedNewProvinceId
                                                          .toString())
                                                  .first
                                                  .areaList
                                                  .where((element) =>
                                                      element.id.toString() ==
                                                      val.toString())
                                                  .first
                                                  .name
                                                  .toString();

                                              Get.find<CartController>()
                                                  .update();
                                            },
                                            items: Get.find<CartController>()
                                                .countryList
                                                .where((element) =>
                                                    element.name ==
                                                    Get.find<CartController>()
                                                        .selectedNewCountryName
                                                        .toString())
                                                .first
                                                .provinceList
                                                .where((element) =>
                                                    element.name ==
                                                    Get.find<CartController>()
                                                        .selectedNewProvinceName
                                                        .toString())
                                                .first
                                                .areaList
                                                .map((AreaModel value) {
                                              return DropdownMenuItem<String>(
                                                value: value.id.toString(),
                                                child:
                                                    Text(value.name.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'Block'),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextField().createTextField(
                                    hint: '',
                                    height: 50,
                                    onTap: () {
                                      Get.find<AddressController>()
                                          .focusTitle
                                          .value = false;
                                      Get.find<AddressController>()
                                              .focusBlock
                                              .value =
                                          !Get.find<AddressController>()
                                              .focusBlock
                                              .value;
                                      Get.find<AddressController>()
                                          .focusAvenue
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusStreet
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusFloor
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusHouseApartment
                                          .value = false;
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 100),
                                          curve: Curves.easeOut);
                                    },
                                    controller: Get.find<AddressController>()
                                        .blockController)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'Street'),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextField().createTextField(
                                    hint: '',
                                    height: 50,
                                    onTap: () {
                                      Get.find<AddressController>()
                                          .focusTitle
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusBlock
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusAvenue
                                          .value = false;
                                      Get.find<AddressController>()
                                              .focusStreet
                                              .value =
                                          !Get.find<AddressController>()
                                              .focusStreet
                                              .value;
                                      Get.find<AddressController>()
                                          .focusFloor
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusHouseApartment
                                          .value = false;
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 100),
                                          curve: Curves.easeOut);
                                    },
                                    controller: Get.find<AddressController>()
                                        .streetController)
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'Avenue'),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextField().createTextField(
                                    hint: '',
                                    height: 50,
                                    onTap: () {
                                      Get.find<AddressController>()
                                          .focusTitle
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusBlock
                                          .value = false;
                                      Get.find<AddressController>()
                                              .focusAvenue
                                              .value =
                                          !Get.find<AddressController>()
                                              .focusAvenue
                                              .value;
                                      Get.find<AddressController>()
                                          .focusStreet
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusFloor
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusHouseApartment
                                          .value = false;
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 100),
                                          curve: Curves.easeOut);
                                    },
                                    controller: Get.find<AddressController>()
                                        .avenueController)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText()
                                    .createText(title: 'House/Apartment'),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextField().createTextField(
                                    hint: '',
                                    height: 50,
                                    onTap: () {
                                      Get.find<AddressController>()
                                          .focusTitle
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusBlock
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusAvenue
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusStreet
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusFloor
                                          .value = false;
                                      Get.find<AddressController>()
                                              .focusHouseApartment
                                              .value =
                                          !Get.find<AddressController>()
                                              .focusHouseApartment
                                              .value;
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 100),
                                          curve: Curves.easeOut);
                                    },
                                    controller: Get.find<AddressController>()
                                        .houseApartmanController)
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: Get.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText().createText(title: 'Floor'),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextField().createTextField(
                                    hint: '',
                                    height: 50,
                                    onTap: () {
                                      Get.find<AddressController>()
                                          .focusTitle
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusBlock
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusAvenue
                                          .value = false;
                                      Get.find<AddressController>()
                                          .focusStreet
                                          .value = false;
                                      Get.find<AddressController>()
                                              .focusFloor
                                              .value =
                                          !Get.find<AddressController>()
                                              .focusFloor
                                              .value;
                                      Get.find<AddressController>()
                                          .focusHouseApartment
                                          .value = false;
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 100),
                                          curve: Curves.easeOut);
                                    },
                                    controller: Get.find<AddressController>()
                                        .floorController)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: SizedBox(
                        width: 150,
                        height: 60,
                        child: CustomTextButton().createTextButton(
                            onPress: () {
                              Get.find<AddressController>()
                                  .updateCustomerAddressRequest(
                                      customerId: userId.toString(),
                                      addressId: addressId.toString(),
                                      areaName: areaNameTxt,
                                      countryName: countryNameTxt,
                                      stateName: stateNameTxt);
                            },
                            elevation: 6,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            buttonText: 'Update',
                            buttonColor: Colors.teal,
                            textColor: Colors.white)),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  createTitleKeyboard(),
                  createBlockKeyboard(),
                  createStreetKeyboard(),
                  createAvenueKeyboard(),
                  createHouseApartmentKeyboard(),
                  createFloorKeyboard(),
                ],
              ),
            );
          })),
    );
  }

  Widget createTitleKeyboard() {
    if (Get.find<AddressController>().focusTitle.isTrue) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350,
          color: const Color(0xffeeeeee),
          child: VirtualKeyboard(
            focusNode: FocusNode(),
            textColor: Colors.black,
            type: VirtualKeyboardType.Alphanumeric,
            textController: Get.find<AddressController>().titleController,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createBlockKeyboard() {
    if (Get.find<AddressController>().focusBlock.isTrue) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350,
          color: const Color(0xffeeeeee),
          child: VirtualKeyboard(
            focusNode: FocusNode(),
            textColor: Colors.black,
            type: VirtualKeyboardType.Alphanumeric,
            textController: Get.find<AddressController>().blockController,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createStreetKeyboard() {
    if (Get.find<AddressController>().focusStreet.isTrue) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350,
          color: const Color(0xffeeeeee),
          child: VirtualKeyboard(
            focusNode: FocusNode(),
            textColor: Colors.black,
            type: VirtualKeyboardType.Alphanumeric,
            textController: Get.find<AddressController>().streetController,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createAvenueKeyboard() {
    if (Get.find<AddressController>().focusAvenue.isTrue) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350,
          color: const Color(0xffeeeeee),
          child: VirtualKeyboard(
            focusNode: FocusNode(),
            textColor: Colors.black,
            type: VirtualKeyboardType.Alphanumeric,
            textController: Get.find<AddressController>().avenueController,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createHouseApartmentKeyboard() {
    if (Get.find<AddressController>().focusHouseApartment.isTrue) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350,
          color: const Color(0xffeeeeee),
          child: VirtualKeyboard(
            focusNode: FocusNode(),
            textColor: Colors.black,
            type: VirtualKeyboardType.Alphanumeric,
            textController:
                Get.find<AddressController>().houseApartmanController,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget createFloorKeyboard() {
    if (Get.find<AddressController>().focusFloor.isTrue) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350,
          color: const Color(0xffeeeeee),
          child: VirtualKeyboard(
            focusNode: FocusNode(),
            textColor: Colors.black,
            type: VirtualKeyboardType.Alphanumeric,
            textController: Get.find<AddressController>().floorController,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
