import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController{
  RxBool isShowKeyboard=false.obs;
  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  TextEditingController searchController = TextEditingController();

  RxInt searchId=1.obs;

  RxBool showProductDetails=false.obs;

  void changeSearchType({required id}){
     searchId.value=id;
     update();
  }

  void fullScreen(){
    document.documentElement!.requestFullscreen();
    if(document.fullscreenEnabled==true){
      document.exitFullscreen();
    }else{
      document.documentElement!.requestFullscreen();
    }
    update();
  }
}