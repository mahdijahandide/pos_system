import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/controller/customer_controller.dart';
import 'package:pos_system/views/components/buttons/custom_text_button.dart';
import 'package:pos_system/views/components/textfields/textfield.dart';
import 'package:pos_system/views/components/texts/customText.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

import '../../../../helper/autocomplete_helper.dart';
import '../../../../services/controller/address_controller.dart';
import '../../../../services/model/customer_address_model.dart';
import '../customer/add_customer_modal.dart';

class CheckoutModal extends GetView<CartController> {
  String title;


  CheckoutModal({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get
        .find<CustomerController>()
        .hasCustomer
        .isFalse) {
      Get.find<CustomerController>()
          .getCustomers(doInBackground: true, hasLoading: false);
    }
    if (Get
        .find<CustomerController>()
        .selectedCustomer != null) {
      Get
          .find<CustomerController>()
          .customerNameController
          .text =
          Get
              .find<CustomerController>()
              .selectedCustomer
              .name ?? '';
      Get
          .find<CustomerController>()
          .searchController
          .text =
          Get
              .find<CustomerController>()
              .selectedCustomer
              .name ?? '';
      Get
          .find<CustomerController>()
          .customerEmailController
          .text =
          Get
              .find<CustomerController>()
              .selectedCustomer
              .email ?? '';
      Get
          .find<CustomerController>()
          .customerNumberController
          .text =
          Get
              .find<CustomerController>()
              .selectedCustomer
              .mobile ?? '';
      Get
          .find<CustomerController>()
          .searchController
          .text =
          Get
              .find<CustomerController>()
              .selectedCustomer
              .name ?? '';
    } else {
      Get
          .find<CustomerController>()
          .searchController
          .text = '';
      Get
          .find<CustomerController>()
          .customerNameController
          .text = '';
      Get
          .find<CustomerController>()
          .customerEmailController
          .text = '';
      Get
          .find<CustomerController>()
          .customerNumberController
          .text = '';
    }

    FocusNode focusNode = FocusNode();

    return Scaffold(
      backgroundColor: Colors.white,
      body:
           Column(
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
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(
                      height: 38,
                    ),
                    Obx(
                          () =>
                      Get
                          .find<CustomerController>()
                          .hasCustomer
                          .isFalse
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : Row(
                        children: [
                          CustomText().createText(title: 'Customer Name: '),
                          const SizedBox(
                            width: 12,
                          ),
                          PopupMenuButton(
                              icon: const Icon(Icons.info),
                              itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: ListTile(
                                      onTap: () {},
                                      leading: const Icon(
                                        Icons.mail,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        Get
                                            .find<CustomerController>()
                                            .selectedCustomer
                                            .email,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      )),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                      onTap: () {},
                                      leading: const Icon(
                                        Icons.phone,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        Get
                                            .find<CustomerController>()
                                            .selectedCustomer
                                            .mobile,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      )),
                                ),
                              ]),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 9,
                            child: TextFieldSearch(
                              focusNode: focusNode,
                              hasKeyboard: true,
                              initialList:
                              Get
                                  .find<CustomerController>()
                                  .customerName,
                              label: 'Customer Name/No',
                              controller: Get
                                  .find<CustomerController>()
                                  .searchController,
                              getSelectedValue: (selected) {
                                Get
                                    .find<CustomerController>()
                                    .selectedCustomer =
                                    Get
                                        .find<CustomerController>()
                                        .customerList
                                        .where((element) =>
                                    element.name == selected)
                                        .first;

                                if (Get
                                    .find<CustomerController>()
                                    .selectedCustomer !=
                                    null) {
                                  Get
                                      .find<CustomerController>()
                                      .customerNameController
                                      .text = Get
                                      .find<CustomerController>()
                                      .selectedCustomer
                                      .name ??
                                      '';
                                  Get
                                      .find<CustomerController>()
                                      .customerEmailController
                                      .text = Get
                                      .find<CustomerController>()
                                      .selectedCustomer
                                      .email ??
                                      '';
                                  Get
                                      .find<CustomerController>()
                                      .customerNumberController
                                      .text = Get
                                      .find<CustomerController>()
                                      .selectedCustomer
                                      .mobile ??
                                      '';
                                } else {
                                  Get
                                      .find<CustomerController>()
                                      .customerNameController
                                      .text = '';
                                  Get
                                      .find<CustomerController>()
                                      .customerEmailController
                                      .text = '';
                                  Get
                                      .find<CustomerController>()
                                      .customerNumberController
                                      .text = '';
                                }
                                Get.find<AddressController>()
                                    .getCustomerAddressRequest(
                                    customerId:
                                    Get
                                        .find<CustomerController>()
                                        .selectedCustomer
                                        .id
                                        .toString(),
                                    hasLoading: true,
                                    closeOverLays: false);

                                Get
                                    .find<AddressController>()
                                    .addresses
                                    .value = Get
                                    .find<CustomerController>()
                                    .selectedCustomer
                                    .addressList;
                                Get.find<CustomerController>().update();
                                Get.find<AddressController>().update();
                                Get.find<CartController>().update();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          IconButton(
                              onPressed: () {
                                controller.hasModalVk.value =
                                !controller.hasModalVk.value;
                              },
                              icon: const Icon(
                                Icons.keyboard,
                                color: Colors.black,
                              )),
                          SizedBox(
                            width: 120,
                            height: 60,
                            child: CustomTextButton().createTextButton(
                                buttonText: 'Create',
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                buttonColor: Colors.teal,
                                textColor: Colors.white,
                                onPress: () async {
                                  if (Get
                                      .find<CartController>()
                                      .countryList
                                      .isEmpty) {
                                    await Get.find<CartController>().getAreas(
                                      doInBackground: true,
                                    );
                                  }
                                  Get.bottomSheet(
                                      AddCustomerModal().createModal(
                                          shouldSelect: true,
                                          customerNumber:
                                          Get
                                              .find<CustomerController>()
                                              .searchController
                                              .text),
                                      isScrollControlled: true);
                                }),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),
                    //customerAddresses
                    GetBuilder(builder: (CartController c){
                      return  Get
                          .find<CartController>()
                          .hasDelivery
                          .isTrue
                          ? const SizedBox()
                          : Get
                          .find<CustomerController>()
                          .selectedCustomer == null
                          ? const SizedBox()
                          : Row(
                        children: [
                          CustomText().createText(
                              title: 'Select Address: ', size: 22),
                          const SizedBox(width: 12,),
                          Expanded(
                            flex: 9,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              focusColor: Colors.white,
                              hint: Text(Get
                                  .find<AddressController>()
                                  .selectedCustomerAddressTitle
                                  .value
                                  .toString()),
                              onChanged: (val) {
                                Get
                                    .find<AddressController>()
                                    .selectedAddress =
                                    Get
                                        .find<AddressController>()
                                        .addresses
                                        .value
                                        .where((element) =>
                                    element.id.toString() ==
                                        val.toString())
                                        .first;

                                Get
                                    .find<AddressController>()
                                    .selectedCustomerAddressTitle
                                    .value =
                                    Get
                                        .find<AddressController>()
                                        .selectedAddress!
                                        .title
                                        .toString();

                                Get
                                    .find<AddressController>()
                                    .selectedCustomerAddressId =
                                    val.toString();

                                Get
                                    .find<CartController>()
                                    .selectedCountryId =
                                    Get
                                        .find<AddressController>()
                                        .selectedAddress!
                                        .countryId
                                        .toString();
                                Get
                                    .find<CartController>()
                                    .selectedCountryName
                                    .value =
                                    Get
                                        .find<AddressController>()
                                        .selectedAddress!
                                        .countryName
                                        .toString();
                                Get
                                    .find<CartController>()
                                    .selectedProvinceId =
                                    Get
                                        .find<AddressController>()
                                        .selectedAddress!
                                        .stateId
                                        .toString();
                                Get
                                    .find<CartController>()
                                    .selectedAreaId =
                                    Get
                                        .find<AddressController>()
                                        .selectedAddress!
                                        .areaId
                                        .toString();
                                Get
                                    .find<CartController>()
                                    .selectedProvinceName
                                    .value =
                                    Get
                                        .find<AddressController>()
                                        .selectedAddress!
                                        .stateName
                                        .toString();
                                Get
                                    .find<CartController>()
                                    .selectedAreaName
                                    .value =
                                    Get
                                        .find<AddressController>()
                                        .selectedAddress!
                                        .areaName
                                        .toString();

                                // Get
                                //     .find<CartController>()
                                //     .deliveryAmount =
                                //     double.parse(Get
                                //         .find<CartController>()
                                //         .countryList
                                //         .where((element) =>
                                //     element.id.toString() ==
                                //         Get
                                //             .find<AddressController>()
                                //             .selectedAddress!
                                //             .countryId
                                //             .toString())
                                //         .first
                                //         .provinceList
                                //         .where((element) =>
                                //     element.id.toString() ==
                                //         Get
                                //             .find<AddressController>()
                                //             .selectedAddress!
                                //             .stateId
                                //             .toString())
                                //         .first
                                //         .areaList
                                //         .where((element) =>
                                //     element.id.toString() ==
                                //         Get
                                //             .find<AddressController>()
                                //             .selectedAddress!
                                //             .areaId
                                //             .toString())
                                //         .first
                                //         .deliveryFee
                                //         .toString());

                                controller.update();
                              },
                              items:
                              Get
                                  .find<AddressController>()
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
                                          '${value.countryName} ${value
                                              .stateName} ${value
                                              .areaName} ave:${value
                                              .avenue} st:${value
                                              .street} house:${value
                                              .house} floor:${value
                                              .floor} block:${value.block}'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          const Expanded(child: SizedBox())
                        ],
                      );
                    }),


                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return Row(
                        children: [
                          CustomText().createText(
                              title: 'Total Amount: ',
                              size: 24,
                              fontWeight: FontWeight.bold),
                          SizedBox(
                            width: 200,
                            child: CustomText().createText(
                                title: (controller.totalAmount -
                                    controller.discountAmount +
                                    controller.deliveryAmount)
                                    .toStringAsFixed(3),
                                size: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomText().createText(
                              title: controller.balanceStatus.value == ''
                                  ? ''
                                  : controller.balanceStatus.value,
                              size: 18,
                              fontWeight: FontWeight.bold,
                              color: controller.calController.text == ''
                                  ? Colors.white
                                  : double.parse(controller.calController.text
                                  .toString()) -
                                  double.parse((controller.totalAmount +
                                      controller.discountAmount +
                                      controller.deliveryAmount)
                                      .toString()) <
                                  0
                                  ? Colors.green
                                  : Colors.red),
                          const Expanded(child: SizedBox())
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width:
                              Get.width > 600 ? Get.width / 3 : Get.width / 2,
                              child: CustomTextField().createTextField(
                                  hint: 'customer Paid',
                                  height: 50,
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        (RegExp("[0-9.]")))
                                  ],
                                  controller: controller.calController,
                                  onSubmitted: (_) async {
                                    String total = (controller.totalAmount -
                                        controller.discountAmount +
                                        controller.deliveryAmount)
                                        .toString();
                                    if (controller.calController.text ==
                                        total) {
                                      controller.checkoutCart();
                                    } else if (double.parse(controller
                                        .calController.text
                                        .toString()) -
                                        double.parse(total) >
                                        0) {
                                      controller.checkoutCart();
                                      controller.balanceStatus.value =
                                      'Change: ${(double.parse(
                                          controller.calController.text
                                              .toString()) -
                                          double.parse(total.toString()))
                                          .toStringAsFixed(3)}';
                                    } else if (double.parse(controller
                                        .calController.text
                                        .toString()) -
                                        double.parse(total) <
                                        0) {
                                      controller.balanceStatus.value =
                                      'Balance: ${(double.parse(
                                          controller.calController.text
                                              .toString()) -
                                          double.parse(total)).toStringAsFixed(
                                          3)}';
                                    }
                                  }),
                            ),
                            Container(
                              width:
                              Get.width > 600 ? Get.width / 3 : Get.width / 2,
                              color: const Color(0xffeeeeee),
                              child: VirtualKeyboard(
                                textColor: Colors.black,
                                type: VirtualKeyboardType.Numeric,
                                textController: controller.calController,
                                focusNode: FocusNode(),
                              ),
                            ),
                            SizedBox(
                              height: 65.0,
                              width:
                              Get.width > 600 ? Get.width / 3 : Get.width / 2,
                              child: CustomTextButton().createTextButton(
                                  onPress: () {
                                    String total = (controller.totalAmount -
                                        controller.discountAmount +
                                        controller.deliveryAmount)
                                        .toString();
                                    if (double.parse(
                                        controller.calController.text)
                                        .toStringAsFixed(3) ==
                                        double.parse(total).toStringAsFixed(
                                            3)) {
                                      controller.checkoutCart();
                                    } else if (double.parse(controller
                                        .calController.text
                                        .toString()) -
                                        double.parse(total) >
                                        0) {
                                      controller.checkoutCart();
                                      controller.balanceStatus.value =
                                      'Change: ${(double.parse(
                                          controller.calController.text
                                              .toString()) -
                                          double.parse(total)).toStringAsFixed(
                                          3)}';
                                    } else if (double.parse(controller
                                        .calController.text
                                        .toString()) -
                                        double.parse(total) <
                                        0) {
                                      controller.balanceStatus.value =
                                      'Balance: ${(double.parse(
                                          controller.calController.text
                                              .toString()) -
                                          double.parse(total)).toStringAsFixed(
                                          3)}';
                                    }
                                  },
                                  buttonText: 'Accept payment',
                                  borderRadius: 0.0,
                                  buttonColor: Colors.teal,
                                  textColor: Colors.white,
                                  icon: const Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(() {
                          return Column(
                            children: [
                              paymentTypeOption(
                                  'Card',
                                  'PCARD',
                                  Icon(
                                    Icons.credit_card,
                                    color: controller.selectedPaymentType
                                        .value ==
                                        'PCARD'
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              paymentTypeOption(
                                  'Cash',
                                  'PCOD',
                                  Icon(
                                    Icons.monetization_on,
                                    color: controller.selectedPaymentType
                                        .value ==
                                        'PCOD'
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              paymentTypeOption(
                                  'Knet',
                                  'PKNET',
                                  Icon(
                                    Icons.attach_money_rounded,
                                    color: controller.selectedPaymentType
                                        .value ==
                                        'PKNET'
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              paymentTypeOption(
                                  'Visa',
                                  'PVISA',
                                  Icon(
                                    Icons.money_rounded,
                                    color: controller.selectedPaymentType
                                        .value ==
                                        'PVISA'
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                            ],
                          );
                        })
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              Obx(() =>
              controller.hasModalVk.isTrue
                  ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 350,
                  color: const Color(0xffeeeeee),
                  child: VirtualKeyboard(
                    textColor: Colors.black,
                    type: VirtualKeyboardType.Alphanumeric,
                    textController:
                    Get
                        .find<CustomerController>()
                        .searchController,
                    focusNode: focusNode,
                  ),
                ),
              )
                  : const SizedBox())
            ],
          )


    );
  }

  Widget paymentTypeOption(String title, String type, Icon ic) {
    return SizedBox(
      height: 80,
      width: 120,
      child: CustomTextButton().createTextButton(
          buttonText: title,
          buttonColor: controller.selectedPaymentType.value == type
              ? Colors.teal
              : Colors.white,
          textSize: controller.selectedPaymentType.value == type ? 20 : 17,
          textColor: controller.selectedPaymentType.value == type
              ? Colors.white
              : Colors.black,
          elevation: 6.0,
          icon: ic,
          onPress: () {
            controller.selectedPaymentType.value = type;
          }),
    );
  }
}
