import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  RxBool focusTitle = false.obs;
  RxBool focusBlock = false.obs;
  RxBool focusStreet = false.obs;
  RxBool focusAvenue = false.obs;
  RxBool focusHouseApartment = false.obs;
  RxBool focusFloor = false.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController avenueController = TextEditingController();
  TextEditingController houseApartmanController = TextEditingController();
  TextEditingController floorController = TextEditingController();
}
