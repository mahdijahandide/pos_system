import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/auth_controller.dart';

import '../../views/components/snackbar/snackbar.dart';

class RemoteStatusHandler {
  void errorHandler({required code, required error}) {
    switch (code) {
      case 400:
        Snack().createSnack(
            title: 'Bad Request', msg: '${error['data']}', bgColor: Colors.red);
        break;
      case 401:
        if (Get.find<AuthController>().token.isEmpty) {
          if (!Get.isSnackbarOpen) {
            Snack().createSnack(
                title: 'Authorization',
                msg: 'Authorization Failed, You Need To Login',
                bgColor: Colors.red);
          }
          Get.toNamed('/login');
        } else {
          print(error);
          Snack().createSnack(
              title: 'Warning',
              msg: 'You Need To Start Cash First',
              bgColor: Colors.red);
        }
        break;
      case 500:
        Snack().createSnack(
            title: 'Server Error', msg: 'Try Again Later', bgColor: Colors.red);
        break;
      default:
    }
  }
}
