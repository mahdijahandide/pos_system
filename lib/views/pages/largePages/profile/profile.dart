import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/services/controller/dashboard_controller.dart';
import 'package:pos_system/services/controller/product_controller.dart';
import 'package:pos_system/services/controller/user_controller.dart';
import 'package:pos_system/views/pages/largePages/dashboard/desktop_dashboard.dart';
import 'package:pos_system/views/pages/largePages/dashboard/mobile_dashboard.dart';
import 'package:pos_system/views/pages/largePages/dashboard/tablet_dashboard.dart';
import 'package:pos_system/views/pages/largePages/profile/desktop_profile.dart';
import 'package:pos_system/views/pages/largePages/profile/mobile_profile.dart';
import 'package:pos_system/views/pages/largePages/profile/tablet_profile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (logic) {
        return ScreenTypeLayout(
          desktop:  const DesktopProfile(),
          tablet:   const TabletProfile(),
          mobile:   const MobileProfile(),
          watch:    Container(color:Colors.white),
        );
      },
    );
  }
}
