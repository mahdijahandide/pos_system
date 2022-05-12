import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../views/components/snackbar/snackbar.dart';





class RemoteStatusHandler{
  void errorHandler({required code}){
    switch(code){
      case 400:
        Snack().createSnack(title: 'Bad Request',msg: 'Request parameters not correct');
        break;
      case 401:
        if(!Get.isSnackbarOpen) {
          Snack().createSnack(title: 'Authorization',msg: 'Authorization Failed, You need to login');
        }
        Get.toNamed('/login');
        break;
      case 500:
        Snack().createSnack(title: 'Server Error',msg: 'Try again Later');
        break;
      default:
    }
  }
}