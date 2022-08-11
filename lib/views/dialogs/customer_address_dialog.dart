import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/address_controller.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/services/model/area_model.dart';
import 'package:pos_system/services/model/city_model.dart';
import 'package:pos_system/services/model/customer_address_model.dart';
import 'package:pos_system/services/model/province_model.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class CustomerAddressDialog {
  static final CustomerAddressDialog _instance =
      CustomerAddressDialog.internal();

  CustomerAddressDialog.internal();

  factory CustomerAddressDialog() => _instance;

  static void showCustomDialog({required title}) {
    Get.defaultDialog(
      title: title,
      barrierDismissible: false,
      content: GetBuilder(builder: (CartController controller) {
        Get.find<AddressController>().addresses.value =
            Get.find<CustomerController>().selectedCustomer.addressList;
        return Container(
          width: Get.width / 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText().createText(
                  title: 'Customer Addresses',
                  size: 18,
                  fontWeight: FontWeight.bold),
              //customerAddresses
              DropdownButton<String>(
                isExpanded: true,
                focusColor: Colors.white,
                hint: Text(Get.find<AddressController>()
                    .selectedCustomerAddressTitle
                    .value
                    .toString()),
                onChanged: (val) {
                  Get.find<AddressController>().selectedAddress = Get.find<AddressController>().addresses.value
                      .where(
                          (element) => element.id.toString() == val.toString())
                      .first;

                  Get.find<AddressController>()
                          .selectedCustomerAddressTitle
                          .value =
                      Get.find<AddressController>()
                          .selectedAddress!
                          .title
                          .toString();

                  Get.find<AddressController>().selectedCustomerAddressId =
                      val.toString();

                  Get.find<CartController>().selectedCountryId =
                      Get.find<AddressController>()
                          .selectedAddress!
                          .countryId
                          .toString();
                  Get.find<CartController>().selectedCountryName.value =
                      Get.find<AddressController>()
                          .selectedAddress!
                          .countryName
                          .toString();
                  Get.find<CartController>().selectedProvinceId =
                      Get.find<AddressController>()
                          .selectedAddress!
                          .stateId
                          .toString();
                  Get.find<CartController>().selectedAreaId =
                      Get.find<AddressController>()
                          .selectedAddress!
                          .areaId
                          .toString();
                  Get.find<CartController>().selectedProvinceName.value =
                      Get.find<AddressController>()
                          .selectedAddress!
                          .stateName
                          .toString();
                  Get.find<CartController>().selectedAreaName.value =
                      Get.find<AddressController>()
                          .selectedAddress!
                          .areaName
                          .toString();

                  Get.find<CartController>().deliveryAmount = double.parse(
                      Get.find<CartController>()
                          .countryList
                          .where((element) =>
                              element.id.toString() ==
                              Get.find<AddressController>()
                                  .selectedAddress!
                                  .countryId
                                  .toString())
                          .first
                          .provinceList
                          .where((element) =>
                              element.id.toString() ==
                              Get.find<AddressController>()
                                  .selectedAddress!
                                  .stateId
                                  .toString())
                          .first
                          .areaList
                          .where((element) =>
                              element.id.toString() ==
                              Get.find<AddressController>()
                                  .selectedAddress!
                                  .areaId
                                  .toString())
                          .first
                          .deliveryFee
                          .toString());

                  controller.update();
                },
                items: Get.find<AddressController>().addresses.value.map((CustomerAddressModel value) {
                  return DropdownMenuItem<String>(
                    value: value.id.toString(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  size: 18,
                  fontWeight: FontWeight.bold),
              //country
              DropdownButton<String>(
                isExpanded: true,
                focusColor: Colors.white,
                hint: Text(
                    Get.find<CartController>().selectedCountryName.toString()),
                onChanged: (val) {
                  Get.find<CartController>().selectedCountryId = val.toString();
                  Get.find<CartController>().selectedCountryName.value =
                      Get.find<CartController>()
                          .countryList
                          .where((element) =>
                              element.id == int.parse(val.toString()))
                          .first
                          .name!;
                  Get.find<CartController>().selectedProvinceId = '';
                  Get.find<CartController>().selectedAreaId = '';
                  Get.find<CartController>().selectedProvinceName.value = '';
                  Get.find<CartController>().selectedAreaName.value = '';
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
                        Get.find<CartController>().selectedProvinceId =
                            val.toString();
                        Get.find<CartController>().selectedProvinceName.value =
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
                                    element.id == int.parse(val.toString()))
                                .first
                                .name
                                .toString();
                        Get.find<CartController>().selectedAreaId = '';
                        Get.find<CartController>().selectedAreaName.value = '';
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
              Get.find<CartController>().selectedProvinceId == ''
                  ? const SizedBox()
                  : DropdownButton<String>(
                      focusColor: Colors.white,
                      isExpanded: true,
                      hint: Text(Get.find<CartController>()
                          .selectedAreaName
                          .toString()),
                      onChanged: (val) {
                        Get.find<CartController>().selectedAreaId =
                            val.toString();

                        Get.find<CartController>().selectedAreaName.value =
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
                                    element.id.toString() == val.toString())
                                .first
                                .name
                                .toString();
                        Get.find<CartController>().deliveryAmount =
                            double.parse(Get.find<CartController>()
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
                                    element.id.toString() == val.toString())
                                .first
                                .deliveryFee
                                .toString());
                        print(Get.find<CartController>().deliveryAmount);
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
            ],
          ),
        );
      }),
      contentPadding: const EdgeInsets.all(15),
      confirm: InkWell(
          onTap: () {
            Get.find<CartController>().getTempOrders(
                cartId: Get.find<CartController>().uniqueId.toString(),
                areaId: Get.find<CartController>().selectedAreaId.toString(),
                userDiscount:
                    Get.find<CartController>().discountAmount.toString());
            Get.find<CartController>().saveCartForSecondMonitor();
          },
          child: Container(
              width: 110,
              height: 50,
              alignment: Alignment.center,
              color: Colors.green.withOpacity(0.2),
              child: CustomText()
                  .createText(title: 'Submit', color: Colors.teal))),
      cancel: InkWell(
          onTap: () {
            Get.find<CartController>().deliveryAmount = 0.0;
            Get.find<CartController>().selectedCountryName.value = '';
            Get.find<CartController>().selectedCountryId = '';
            Get.find<CartController>().selectedProvinceName.value = '';
            Get.find<CartController>().selectedProvinceId = '';
            Get.find<CartController>().selectedAreaName.value = '';
            Get.find<CartController>().selectedAreaId = '';
            Get.find<CartController>().hasDelivery.value=false;
            Get.find<CartController>().update();
            Get.back();
          },
          child: Container(
            width: 110,
            height: 50,
            alignment: Alignment.center,
            color: Colors.red.withOpacity(0.2),
            child: CustomText()
                .createText(title: 'Cancel Delivery', color: Colors.red),
          )),
    );
  }
}
