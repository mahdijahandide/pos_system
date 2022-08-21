import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';

import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../../../services/controller/address_controller.dart';
import '../../../../services/model/area_model.dart';
import '../../../../services/model/city_model.dart';

import '../../../../services/model/customer_address_model.dart';
import '../../../../services/model/province_model.dart';
import '../../../components/snackbar/snackbar.dart';

class CustomerAreaModal extends GetView<CartController> {
  String title;
  final ScrollController _controller = ScrollController();

  CustomerAreaModal({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<AddressController>().selectedAddress != null &&
        Get.find<CartController>().hasDelivery.isTrue) {
      Get.find<AddressController>().streetController.text =
          Get.find<AddressController>().selectedAddress!.street.toString();
      Get.find<AddressController>().avenueController.text =
          Get.find<AddressController>().selectedAddress!.avenue.toString();
      Get.find<AddressController>().blockController.text =
          Get.find<AddressController>().selectedAddress!.block.toString();
      Get.find<AddressController>().houseApartmanController.text =
          Get.find<AddressController>().selectedAddress!.house.toString();
      Get.find<AddressController>().floorController.text =
          Get.find<AddressController>().selectedAddress!.floor.toString();
    } else {
      Get.find<AddressController>().selectedAddress = null;
      Get.find<AddressController>().streetController.text = '';
      Get.find<AddressController>().avenueController.text = '';
      Get.find<AddressController>().blockController.text = '';
      Get.find<AddressController>().houseApartmanController.text = '';
      Get.find<AddressController>().floorController.text = '';
      Get.find<CartController>().selectedCountryName.value = 'Select Country';
      Get.find<CartController>().selectedProvinceName.value = 'Select Province';
      Get.find<CartController>().selectedAreaName.value = 'Select Area';
      Get.find<CartController>().selectedCountryId = '';
      Get.find<CartController>().selectedProvinceId = '';
      Get.find<CartController>().selectedAreaId = '';
    }
    closeAllKeyboards();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  CustomText().createText(
                      color: Colors.black,
                      title: title,
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
            GetBuilder(builder: (CartController controller) {
              Get.find<AddressController>().addresses.value =
                  Get.find<CustomerController>().selectedCustomer.addressList;
              return GestureDetector(
                onTap: () {
                  closeAllKeyboards();
                  controller.update();
                },
                child: Container(
                  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText().createText(
                                  title: 'Customer Addresses',
                                  align: TextAlign.start),
                              //customerAddresses
                              DropdownButton<String>(
                                isExpanded: true,
                                focusColor: Colors.white,
                                hint: Text(Get.find<AddressController>()
                                    .selectedCustomerAddressTitle
                                    .value
                                    .toString()),
                                onChanged: (val) {
                                  controller.deliveryAmount = 0.0;
                                  controller.deliveryAmountForPrint = 0.0;
                                  Get.find<AddressController>()
                                      .selectedAddress = null;
                                  controller.customerAddressForPrint = '';
                                  Get.find<AddressController>()
                                          .selectedAddress =
                                      Get.find<AddressController>()
                                          .addresses
                                          .value
                                          .where((element) =>
                                              element.id.toString() ==
                                              val.toString())
                                          .first;

                                  Get.find<AddressController>()
                                          .selectedCustomerAddressTitle
                                          .value =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .title
                                          .toString();

                                  Get.find<AddressController>()
                                          .selectedCustomerAddressId =
                                      val.toString();

                                  Get.find<CartController>().selectedCountryId =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .countryId
                                          .toString();
                                  Get.find<CartController>()
                                          .selectedCountryName
                                          .value =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .countryName
                                          .toString();
                                  Get.find<CartController>()
                                          .selectedProvinceId =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .stateId
                                          .toString();
                                  Get.find<CartController>().selectedAreaId =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .areaId
                                          .toString();
                                  Get.find<CartController>()
                                          .selectedProvinceName
                                          .value =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .stateName
                                          .toString();
                                  Get.find<CartController>()
                                          .selectedAreaName
                                          .value =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .areaName
                                          .toString();

                                  Get.find<AddressController>()
                                          .streetController
                                          .text =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .street
                                          .toString();

                                  Get.find<AddressController>()
                                          .avenueController
                                          .text =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .avenue
                                          .toString();

                                  Get.find<AddressController>()
                                          .houseApartmanController
                                          .text =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .house
                                          .toString();

                                  Get.find<AddressController>()
                                          .floorController
                                          .text =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .floor
                                          .toString();

                                  Get.find<AddressController>()
                                          .blockController
                                          .text =
                                      Get.find<AddressController>()
                                          .selectedAddress!
                                          .block
                                          .toString();

                                  controller.update();
                                },
                                items: Get.find<AddressController>()
                                    .addresses
                                    .value
                                    .map((CustomerAddressModel value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(value.title.toString()),
                                        Text(
                                            '${value.countryName} ${value.stateName} ${value.areaName} ave:${value.avenue} st:${value.street} house:${value.house} floor:${value.floor} block:${value.block}'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              CustomText().createText(
                                title: 'Custom Address',
                              ),
                              //country
                              DropdownButton<String>(
                                isExpanded: true,
                                focusColor: Colors.white,
                                hint: Text(Get.find<CartController>()
                                    .selectedCountryName
                                    .toString()),
                                onChanged: (val) {
                                  controller.deliveryAmount = 0.0;
                                  controller.deliveryAmountForPrint = 0.0;
                                  Get.find<AddressController>()
                                      .selectedAddress = null;
                                  controller.customerAddressForPrint = '';
                                  Get.find<CartController>().selectedCountryId =
                                      val.toString();
                                  Get.find<CartController>()
                                          .selectedCountryName
                                          .value =
                                      Get.find<CartController>()
                                          .countryList
                                          .where((element) =>
                                              element.id ==
                                              int.parse(val.toString()))
                                          .first
                                          .name!;
                                  Get.find<CartController>()
                                      .selectedProvinceId = '';
                                  Get.find<CartController>().selectedAreaId =
                                      '';
                                  Get.find<CartController>()
                                      .selectedProvinceName
                                      .value = 'Select Province';
                                  Get.find<CartController>()
                                      .selectedAreaName
                                      .value = 'Select Area';
                                  controller.update();
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

                              //province
                              Get.find<CartController>().selectedCountryId == ''
                                  ? const SizedBox()
                                  : DropdownButton<String>(
                                      focusColor: Colors.white,
                                      isExpanded: true,
                                      hint: Text(Get.find<CartController>()
                                          .selectedProvinceName
                                          .toString()),
                                      onChanged: (val) {
                                        controller.deliveryAmount = 0.0;
                                        controller.deliveryAmountForPrint = 0.0;
                                        Get.find<AddressController>()
                                            .selectedAddress = null;
                                        controller.customerAddressForPrint = '';
                                        Get.find<CartController>()
                                                .selectedProvinceId =
                                            val.toString();
                                        Get.find<CartController>()
                                                .selectedProvinceName
                                                .value =
                                            Get.find<CartController>()
                                                .countryList
                                                .where((element) =>
                                                    element.name ==
                                                    Get.find<CartController>()
                                                        .selectedCountryName
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
                                            .selectedAreaId = '';
                                        Get.find<CartController>()
                                            .selectedAreaName
                                            .value = 'Select Area';
                                        controller.update();
                                      },
                                      items: Get.find<CartController>()
                                          .countryList
                                          .where((element) =>
                                              element.name ==
                                              Get.find<CartController>()
                                                  .selectedCountryName
                                                  .toString())
                                          .first
                                          .provinceList
                                          .map((CityModel value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id.toString(),
                                          child: Text(value.name.toString()),
                                        );
                                      }).toList(),
                                    ),

                              //area
                              Get.find<CartController>().selectedProvinceId ==
                                      ''
                                  ? const SizedBox()
                                  : DropdownButton<String>(
                                      focusColor: Colors.white,
                                      isExpanded: true,
                                      hint: Text(Get.find<CartController>()
                                          .selectedAreaName
                                          .toString()),
                                      onChanged: (val) {
                                        controller.deliveryAmount = 0.0;
                                        controller.deliveryAmountForPrint = 0.0;
                                        Get.find<AddressController>()
                                            .selectedAddress = null;
                                        controller.customerAddressForPrint = '';
                                        Get.find<CartController>()
                                            .selectedAreaId = val.toString();

                                        Get.find<CartController>()
                                                .selectedAreaName
                                                .value =
                                            Get.find<CartController>()
                                                .countryList
                                                .where((element) =>
                                                    element.name ==
                                                    Get.find<CartController>()
                                                        .selectedCountryName
                                                        .value)
                                                .first
                                                .provinceList
                                                .where((element) =>
                                                    element.id.toString() ==
                                                    Get.find<CartController>()
                                                        .selectedProvinceId
                                                        .toString())
                                                .first
                                                .areaList
                                                .where((element) =>
                                                    element.id.toString() ==
                                                    val.toString())
                                                .first
                                                .name
                                                .toString();

                                        controller.update();
                                      },
                                      items: Get.find<CartController>()
                                          .countryList
                                          .where((element) =>
                                              element.name ==
                                              Get.find<CartController>()
                                                  .selectedCountryName
                                                  .toString())
                                          .first
                                          .provinceList
                                          .where((element) =>
                                              element.name ==
                                              Get.find<CartController>()
                                                  .selectedProvinceName
                                                  .toString())
                                          .first
                                          .areaList
                                          .map((AreaModel value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id.toString(),
                                          child: Text(value.name.toString()),
                                        );
                                      }).toList(),
                                    ),

                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText()
                                            .createText(title: 'Street'),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        CustomTextField().createTextField(
                                            hint: '',
                                            height: 50,
                                            onTap: () {
                                              if (Get.find<AddressController>()
                                                  .focusStreet
                                                  .isFalse) {
                                                Get.find<CustomerController>()
                                                    .focusName
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusNumber
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusEmail
                                                    .value = false;

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
                                                    .value = !Get.find<
                                                        AddressController>()
                                                    .focusStreet
                                                    .value;
                                                Get.find<AddressController>()
                                                    .focusFloor
                                                    .value = false;
                                                Get.find<AddressController>()
                                                    .focusHouseApartment
                                                    .value = false;
                                                _controller.jumpTo(_controller
                                                    .position.maxScrollExtent);
                                                controller.update();
                                              }
                                            },
                                            controller:
                                                Get.find<AddressController>()
                                                    .streetController)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText()
                                            .createText(title: 'Avenue'),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        CustomTextField().createTextField(
                                            hint: '',
                                            height: 50,
                                            onTap: () {
                                              if (Get.find<AddressController>()
                                                  .focusAvenue
                                                  .isFalse) {
                                                Get.find<CustomerController>()
                                                    .focusName
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusNumber
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusEmail
                                                    .value = false;

                                                Get.find<AddressController>()
                                                    .focusTitle
                                                    .value = false;
                                                Get.find<AddressController>()
                                                    .focusBlock
                                                    .value = false;
                                                Get.find<AddressController>()
                                                    .focusAvenue
                                                    .value = !Get.find<
                                                        AddressController>()
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
                                                _controller.jumpTo(_controller
                                                    .position.maxScrollExtent);
                                                controller.update();
                                              }
                                            },
                                            controller:
                                                Get.find<AddressController>()
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText().createText(
                                            title: 'House/Apartment'),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        CustomTextField().createTextField(
                                            hint: '',
                                            height: 50,
                                            onTap: () {
                                              if (Get.find<AddressController>()
                                                  .focusHouseApartment
                                                  .isFalse) {
                                                Get.find<CustomerController>()
                                                    .focusName
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusNumber
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusEmail
                                                    .value = false;

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
                                                    .value = !Get.find<
                                                        AddressController>()
                                                    .focusHouseApartment
                                                    .value;
                                                _controller.jumpTo(_controller
                                                    .position.maxScrollExtent);
                                                controller.update();
                                              }
                                            },
                                            controller:
                                                Get.find<AddressController>()
                                                    .houseApartmanController)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText().createText(title: 'Floor'),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        CustomTextField().createTextField(
                                            hint: '',
                                            height: 50,
                                            onTap: () {
                                              if (Get.find<AddressController>()
                                                  .focusFloor
                                                  .isFalse) {
                                                Get.find<CustomerController>()
                                                    .focusName
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusNumber
                                                    .value = false;
                                                Get.find<CustomerController>()
                                                    .focusEmail
                                                    .value = false;

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
                                                    .value = !Get.find<
                                                        AddressController>()
                                                    .focusFloor
                                                    .value;
                                                Get.find<AddressController>()
                                                    .focusHouseApartment
                                                    .value = false;
                                                _controller.jumpTo(_controller
                                                    .position.maxScrollExtent);
                                                controller.update();
                                              }
                                            },
                                            controller:
                                                Get.find<AddressController>()
                                                    .floorController)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Center(
                                child: SizedBox(
                                  width: Get.width / 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText().createText(title: 'Block'),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      CustomTextField().createTextField(
                                          hint: '',
                                          height: 50,
                                          onTap: () {
                                            if (Get.find<AddressController>()
                                                .focusBlock
                                                .isFalse) {
                                              Get.find<CustomerController>()
                                                  .focusName
                                                  .value = false;
                                              Get.find<CustomerController>()
                                                  .focusNumber
                                                  .value = false;
                                              Get.find<CustomerController>()
                                                  .focusEmail
                                                  .value = false;

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
                                              _controller.jumpTo(_controller
                                                  .position.maxScrollExtent);
                                              controller.update();
                                            }
                                          },
                                          controller:
                                              Get.find<AddressController>()
                                                  .blockController)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (Get.find<CartController>()
                                                .selectedCountryId
                                                .isNotEmpty &&
                                            Get.find<CartController>()
                                                .selectedProvinceId
                                                .isNotEmpty &&
                                            Get.find<CartController>()
                                                .selectedAreaId
                                                .isNotEmpty) {
                                          Get.find<CartController>()
                                              .getTempOrders(
                                                  cartId:
                                                      Get.find<CartController>()
                                                          .uniqueId
                                                          .toString(),
                                                  areaId:
                                                      Get.find<CartController>()
                                                          .selectedAreaId
                                                          .toString(),
                                                  userDiscount:
                                                      Get.find<CartController>()
                                                          .discountAmount
                                                          .toString());
                                          Get.find<CartController>()
                                              .saveCartForSecondMonitor();

                                          Get.find<CartController>()
                                                  .customerAddressForPrint =
                                              '${Get.find<CartController>().selectedCountryName} ${Get.find<CartController>().selectedProvinceName} ${Get.find<CartController>().selectedAreaName} ave:${Get.find<AddressController>().avenueController.text} st:${Get.find<AddressController>().streetController.text} house:${Get.find<AddressController>().houseApartmanController.text} floor:${Get.find<AddressController>().floorController.text} block:${Get.find<AddressController>().blockController.text}';
                                        } else {
                                          Snack().createSnack(
                                              title: 'warning',
                                              msg: 'Please fill the form',
                                              bgColor: Colors.yellow,
                                              msgColor: Colors.black,
                                              titleColor: Colors.black);
                                        }
                                      },
                                      child: Container(
                                          width: 110,
                                          height: 50,
                                          alignment: Alignment.center,
                                          color: Colors.green.withOpacity(0.2),
                                          child: CustomText().createText(
                                              title: 'Submit',
                                              color: Colors.teal))),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Get.find<CartController>()
                                            .deliveryAmount = 0.0;
                                        Get.find<CartController>()
                                            .selectedCountryName
                                            .value = '';
                                        Get.find<CartController>()
                                            .selectedCountryId = '';
                                        Get.find<CartController>()
                                            .selectedProvinceName
                                            .value = '';
                                        Get.find<CartController>()
                                            .selectedProvinceId = '';
                                        Get.find<CartController>()
                                            .selectedAreaName
                                            .value = '';
                                        Get.find<CartController>()
                                            .selectedAreaId = '';
                                        Get.find<CartController>()
                                            .customerAddressForPrint = '';
                                        Get.find<CartController>()
                                            .hasDelivery
                                            .value = false;
                                        Get.find<CartController>().update();
                                        Get.back();
                                      },
                                      child: Container(
                                        width: 110,
                                        height: 50,
                                        alignment: Alignment.center,
                                        color: Colors.red.withOpacity(0.2),
                                        child: CustomText().createText(
                                            title: 'Cancel Delivery',
                                            color: Colors.red),
                                      )),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: [
                          Get.find<AddressController>().focusBlock.isTrue
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 350,
                                    color: const Color(0xffeeeeee),
                                    child: VirtualKeyboard(
                                      focusNode: FocusNode(),
                                      textColor: Colors.black,
                                      type: VirtualKeyboardType.Alphanumeric,
                                      textController:
                                          Get.find<AddressController>()
                                              .blockController,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Get.find<AddressController>().focusStreet.isTrue
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 350,
                                    color: const Color(0xffeeeeee),
                                    child: VirtualKeyboard(
                                      focusNode: FocusNode(),
                                      textColor: Colors.black,
                                      type: VirtualKeyboardType.Alphanumeric,
                                      textController:
                                          Get.find<AddressController>()
                                              .streetController,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Get.find<AddressController>().focusAvenue.isTrue
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 350,
                                    color: const Color(0xffeeeeee),
                                    child: VirtualKeyboard(
                                      focusNode: FocusNode(),
                                      textColor: Colors.black,
                                      type: VirtualKeyboardType.Alphanumeric,
                                      textController:
                                          Get.find<AddressController>()
                                              .avenueController,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Get.find<AddressController>()
                                  .focusHouseApartment
                                  .isTrue
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 350,
                                    color: const Color(0xffeeeeee),
                                    child: VirtualKeyboard(
                                      focusNode: FocusNode(),
                                      textColor: Colors.black,
                                      type: VirtualKeyboardType.Alphanumeric,
                                      textController:
                                          Get.find<AddressController>()
                                              .houseApartmanController,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Get.find<AddressController>().focusFloor.isTrue
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 350,
                                    color: const Color(0xffeeeeee),
                                    child: VirtualKeyboard(
                                      focusNode: FocusNode(),
                                      textColor: Colors.black,
                                      type: VirtualKeyboardType.Alphanumeric,
                                      textController:
                                          Get.find<AddressController>()
                                              .floorController,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          ],
        ));
  }

  static int flexForSc() {
    bool keyboardIsGone = false;
    if (Get.find<CustomerController>().focusName.isFalse &&
        Get.find<CustomerController>().focusNumber.isFalse &&
        Get.find<CustomerController>().focusEmail.isFalse &&
        Get.find<AddressController>().focusTitle.isFalse &&
        Get.find<AddressController>().focusBlock.isFalse &&
        Get.find<AddressController>().focusAvenue.isFalse &&
        Get.find<AddressController>().focusStreet.isFalse &&
        Get.find<AddressController>().focusFloor.isFalse &&
        Get.find<AddressController>().focusHouseApartment.isFalse) {
      keyboardIsGone = false;
    } else {
      keyboardIsGone = true;
    }
    return keyboardIsGone == false ? 0 : 3;
  }

  void closeAllKeyboards() {
    Get.find<CustomerController>().focusName.value = false;
    Get.find<CustomerController>().focusNumber.value = false;
    Get.find<CustomerController>().focusEmail.value = false;
    Get.find<AddressController>().focusTitle.value = false;
    Get.find<AddressController>().focusBlock.value = false;
    Get.find<AddressController>().focusAvenue.value = false;
    Get.find<AddressController>().focusStreet.value = false;
    Get.find<AddressController>().focusFloor.value = false;
    Get.find<AddressController>().focusHouseApartment.value = false;
  }

  // This is what you're looking for!
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
