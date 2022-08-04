import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/shift_controller.dart';
import 'package:pos_system/views/components/texts/customText.dart';

import '../../services/controller/address_controller.dart';
import '../../services/controller/cart_controller.dart';
import '../../services/controller/customer_controller.dart';
import '../../services/model/area_model.dart';
import '../../services/model/city_model.dart';
import '../../services/model/province_model.dart';
import '../components/textfields/textfield.dart';

class UpdateCustomerDialog {
  static final UpdateCustomerDialog _instance = UpdateCustomerDialog.internal();

  UpdateCustomerDialog.internal();

  factory UpdateCustomerDialog() => _instance;

  static void showCustomDialog({required title, required msg}) {
    Get.defaultDialog(
      content: Column(
        children: [
          CustomText().createText(
              title: 'Customer Address', fontWeight: FontWeight.bold, size: 22),
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
                          Get.find<CustomerController>().focusName.value =
                              false;
                          Get.find<CustomerController>().focusNumber.value =
                              false;
                          Get.find<CustomerController>().focusEmail.value =
                              false;

                          Get.find<AddressController>().focusTitle.value =
                              !Get.find<AddressController>().focusTitle.value;
                          Get.find<AddressController>().focusBlock.value =
                              false;
                          Get.find<AddressController>().focusAvenue.value =
                              false;
                          Get.find<AddressController>().focusStreet.value =
                              false;
                          Get.find<AddressController>().focusFloor.value =
                              false;
                          Get.find<AddressController>()
                              .focusHouseApartment
                              .value = false;
                          // _controller.animateTo(
                          //     _controller.position.maxScrollExtent,
                          // duration:
                          // const Duration(milliseconds: 100),
                          // curve: Curves.easeOut);
                        },
                        controller:
                            Get.find<AddressController>().titleController)
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
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1.2, color: Colors.grey.withOpacity(0.5))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          focusColor: Colors.white,
                          hint: Text(Get.find<CartController>()
                              .selectedNewCountryName
                              .toString()),
                          onChanged: (val) {
                            Get.find<CartController>().selectedNewCountryId =
                                val.toString();
                            Get.find<CartController>()
                                    .selectedNewCountryName
                                    .value =
                                Get.find<CartController>()
                                    .countryList
                                    .where((element) =>
                                        element.id == int.parse(val.toString()))
                                    .first
                                    .name!;
                            Get.find<CartController>().selectedNewProvinceId =
                                '';
                            Get.find<CartController>().selectedNewAreaId = '';
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
                    Get.find<CartController>().selectedNewCountryId == ''
                        ? Container(
                            height: 50,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.2,
                                    color: Colors.grey.withOpacity(0.5))),
                          )
                        : Container(
                            height: 50,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.2,
                                    color: Colors.grey.withOpacity(0.5))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                focusColor: Colors.white,
                                isExpanded: true,
                                hint: Text(Get.find<CartController>()
                                    .selectedNewProvinceName
                                    .toString()),
                                onChanged: (val) {
                                  Get.find<CartController>()
                                      .selectedNewProvinceId = val.toString();
                                  Get.find<CartController>()
                                          .selectedNewProvinceName
                                          .value =
                                      Get.find<CartController>()
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
                                  Get.find<CartController>().selectedNewAreaId =
                                      '';
                                  Get.find<CartController>()
                                      .selectedNewAreaName
                                      .value = '';
                                  Get.find<CartController>().update();
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
                                    child: Text(value.name.toString()),
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
                    Get.find<CartController>().selectedNewProvinceId == ''
                        ? Container(
                            height: 50,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.2,
                                    color: Colors.grey.withOpacity(0.5))),
                          )
                        : Container(
                            height: 50,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.2,
                                    color: Colors.grey.withOpacity(0.5))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                focusColor: Colors.white,
                                isExpanded: true,
                                hint: Text(Get.find<CartController>()
                                    .selectedNewAreaName
                                    .toString()),
                                onChanged: (val) {
                                  Get.find<CartController>().selectedNewAreaId =
                                      val.toString();

                                  Get.find<CartController>()
                                          .selectedNewAreaName
                                          .value =
                                      Get.find<CartController>()
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

                                  Get.find<CartController>().update();
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
                    CustomText().createText(title: 'Block'),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextField().createTextField(
                        hint: '',
                        height: 50,
                        onTap: () {
                          Get.find<CustomerController>().focusName.value =
                              false;
                          Get.find<CustomerController>().focusNumber.value =
                              false;
                          Get.find<CustomerController>().focusEmail.value =
                              false;

                          Get.find<AddressController>().focusTitle.value =
                              false;
                          Get.find<AddressController>().focusBlock.value =
                              !Get.find<AddressController>().focusBlock.value;
                          Get.find<AddressController>().focusAvenue.value =
                              false;
                          Get.find<AddressController>().focusStreet.value =
                              false;
                          Get.find<AddressController>().focusFloor.value =
                              false;
                          Get.find<AddressController>()
                              .focusHouseApartment
                              .value = false;
                          // _controller.animateTo(
                          //     _controller.position.maxScrollExtent,
                          //     duration:
                          //         const Duration(milliseconds: 100),
                          //     curve: Curves.easeOut);
                        },
                        controller:
                            Get.find<AddressController>().blockController)
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
                          Get.find<CustomerController>().focusName.value =
                              false;
                          Get.find<CustomerController>().focusNumber.value =
                              false;
                          Get.find<CustomerController>().focusEmail.value =
                              false;

                          Get.find<AddressController>().focusTitle.value =
                              false;
                          Get.find<AddressController>().focusBlock.value =
                              false;
                          Get.find<AddressController>().focusAvenue.value =
                              false;
                          Get.find<AddressController>().focusStreet.value =
                              !Get.find<AddressController>().focusStreet.value;
                          Get.find<AddressController>().focusFloor.value =
                              false;
                          Get.find<AddressController>()
                              .focusHouseApartment
                              .value = false;
                          // _controller.animateTo(
                          //     _controller.position.maxScrollExtent,
                          //     duration:
                          //         const Duration(milliseconds: 100),
                          //     curve: Curves.easeOut);
                        },
                        controller:
                            Get.find<AddressController>().streetController)
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
                          Get.find<CustomerController>().focusName.value =
                              false;
                          Get.find<CustomerController>().focusNumber.value =
                              false;
                          Get.find<CustomerController>().focusEmail.value =
                              false;

                          Get.find<AddressController>().focusTitle.value =
                              false;
                          Get.find<AddressController>().focusBlock.value =
                              false;
                          Get.find<AddressController>().focusAvenue.value =
                              !Get.find<AddressController>().focusAvenue.value;
                          Get.find<AddressController>().focusStreet.value =
                              false;
                          Get.find<AddressController>().focusFloor.value =
                              false;
                          Get.find<AddressController>()
                              .focusHouseApartment
                              .value = false;
                          // _controller.animateTo(
                          //     _controller.position.maxScrollExtent,
                          //     duration:
                          //         const Duration(milliseconds: 100),
                          //     curve: Curves.easeOut);
                        },
                        controller:
                            Get.find<AddressController>().avenueController)
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
                    CustomText().createText(title: 'House/Apartment'),
                    const SizedBox(
                      height: 6,
                    ),
                    CustomTextField().createTextField(
                        hint: '',
                        height: 50,
                        onTap: () {
                          Get.find<CustomerController>().focusName.value =
                              false;
                          Get.find<CustomerController>().focusNumber.value =
                              false;
                          Get.find<CustomerController>().focusEmail.value =
                              false;

                          Get.find<AddressController>().focusTitle.value =
                              false;
                          Get.find<AddressController>().focusBlock.value =
                              false;
                          Get.find<AddressController>().focusAvenue.value =
                              false;
                          Get.find<AddressController>().focusStreet.value =
                              false;
                          Get.find<AddressController>().focusFloor.value =
                              false;
                          Get.find<AddressController>()
                                  .focusHouseApartment
                                  .value =
                              !Get.find<AddressController>()
                                  .focusHouseApartment
                                  .value;
                          // _controller.animateTo(
                          //     _controller.position.maxScrollExtent,
                          //     duration:
                          //         const Duration(milliseconds: 100),
                          //     curve: Curves.easeOut);
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
                          Get.find<CustomerController>().focusName.value =
                              false;
                          Get.find<CustomerController>().focusNumber.value =
                              false;
                          Get.find<CustomerController>().focusEmail.value =
                              false;

                          Get.find<AddressController>().focusTitle.value =
                              false;
                          Get.find<AddressController>().focusBlock.value =
                              false;
                          Get.find<AddressController>().focusAvenue.value =
                              false;
                          Get.find<AddressController>().focusStreet.value =
                              false;
                          Get.find<AddressController>().focusFloor.value =
                              !Get.find<AddressController>().focusFloor.value;
                          Get.find<AddressController>()
                              .focusHouseApartment
                              .value = false;
                          // _controller.animateTo(
                          //     _controller.position.maxScrollExtent,
                          //     duration:
                          //         const Duration(milliseconds: 100),
                          //     curve: Curves.easeOut);
                        },
                        controller:
                            Get.find<AddressController>().floorController)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      confirm: InkWell(
          onTap: () {
            Get.back();
            Get.find<ShiftController>().endCashRequest();
          },
          child: Container(
              width: 110,
              height: 50,
              alignment: Alignment.center,
              color: Colors.green.withOpacity(0.2),
              child: CustomText()
                  .createText(title: 'Save anyway', color: Colors.teal))),
      cancel: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 110,
            height: 50,
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.2),
            child: CustomText().createText(title: 'Cancel', color: Colors.red),
          )),
    );
  }
}
