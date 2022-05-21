import 'package:flutter/material.dart';
import 'package:pos_system/views/pages/largePages/login/desktop_login.dart';
import 'package:pos_system/views/pages/largePages/login/mobile_login.dart';
import 'package:pos_system/views/pages/largePages/login/tablet_login.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   // Get.find<AuthController>().clearProject();
    return ScreenTypeLayout(
        desktop: DesktopLogin(),
        mobile:  MobileLogin(),
        tablet:  TabletLogin(),
        watch:   Container(color:Colors.white),
      );
  }
}
